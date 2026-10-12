package com.nexlabs.nexid

import android.app.Activity
import android.content.Intent
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.Ndef
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.plugin.common.MethodChannel
import java.nio.charset.Charset

/**
 * Gestor nativo en Kotlin para lectura de tarjetas NFC (NDEF, IsoDep, Mifare, NfcA/B/F/V).
 */
class NfcHardwareManager(
    private val activity: Activity,
    private val channel: MethodChannel
) : NfcAdapter.ReaderCallback {

    private val nfcAdapter: NfcAdapter? = NfcAdapter.getDefaultAdapter(activity)
    private val mainHandler = Handler(Looper.getMainLooper())
    private var isReaderActive = false

    fun getNfcStatus(): String {
        val adapter = nfcAdapter ?: return "not_supported"
        return if (adapter.isEnabled) "enabled" else "disabled"
    }

    fun startReaderMode(): Boolean {
        val adapter = nfcAdapter ?: return false
        if (!adapter.isEnabled) return false

        val flags = NfcAdapter.FLAG_READER_NFC_A or
                NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or
                NfcAdapter.FLAG_READER_NFC_V or
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS

        val options = Bundle().apply {
            putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)
        }

        adapter.enableReaderMode(activity, this, flags, options)
        isReaderActive = true
        return true
    }

    fun stopReaderMode() {
        if (isReaderActive) {
            nfcAdapter?.disableReaderMode(activity)
            isReaderActive = false
        }
    }

    fun openNfcSettings() {
        val intent = Intent(Settings.ACTION_NFC_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        activity.startActivity(intent)
    }

    override fun onTagDiscovered(tag: Tag?) {
        if (tag == null) return
        processTag(tag)
    }

    fun handleIntent(intent: Intent?) {
        if (intent == null) return
        val action = intent.action ?: return
        if (action == NfcAdapter.ACTION_NDEF_DISCOVERED ||
            action == NfcAdapter.ACTION_TECH_DISCOVERED ||
            action == NfcAdapter.ACTION_TAG_DISCOVERED
        ) {
            val tag: Tag? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)
            }
            if (tag != null) {
                processTag(tag)
            }
        }
    }

    private fun processTag(tag: Tag) {
        val uidHex = tag.id.joinToString("") { "%02X".format(it) }
        val techList = tag.techList.map { it.substringAfterLast('.') }
        val ndefText = extractNdefPayload(tag)
        val resolvedToken = if (!ndefText.isNullOrBlank()) {
            ndefText.trim()
        } else {
            "CARD-NFC-$uidHex"
        }

        val payload = mapOf(
            "token" to resolvedToken,
            "uid" to uidHex,
            "techList" to techList
        )

        mainHandler.post {
            channel.invokeMethod("onNfcTagRead", payload)
        }
    }

    private fun extractNdefPayload(tag: Tag): String? {
        val ndef = Ndef.get(tag) ?: return null
        return try {
            ndef.connect()
            val message: NdefMessage? = ndef.ndefMessage ?: ndef.cachedNdefMessage
            val firstRecord = message?.records?.firstOrNull()
            decodeRecord(firstRecord)
        } catch (_: Exception) {
            null
        } finally {
            try {
                ndef.close()
            } catch (_: Exception) {
            }
        }
    }

    private fun decodeRecord(record: NdefRecord?): String? {
        if (record == null) return null
        val payload = record.payload
        if (payload.isEmpty()) return null

        return if (record.tnf == NdefRecord.TNF_WELL_KNOWN &&
            record.type.contentEquals(NdefRecord.RTD_TEXT)
        ) {
            val languageCodeLength = payload[0].toInt() and 0x3F
            val textEncoding = if ((payload[0].toInt() and 0x80) == 0) "UTF-8" else "UTF-16"
            if (payload.size > languageCodeLength + 1) {
                String(
                    payload,
                    languageCodeLength + 1,
                    payload.size - languageCodeLength - 1,
                    Charset.forName(textEncoding)
                )
            } else {
                null
            }
        } else {
            String(payload, Charset.forName("UTF-8"))
        }
    }
}
