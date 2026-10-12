package com.nexlabs.nexid

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Actividad principal en Kotlin que coordina los canales nativos de NFC y Camara QR.
 */
class MainActivity : FlutterActivity() {
    companion object {
        private const val HARDWARE_CHANNEL = "com.nexlabs.nexid/hardware"
    }

    private var nfcManager: NfcHardwareManager? = null
    private var cameraQrManager: CameraQrManager? = null
    private var capabilitiesManager: DeviceCapabilitiesManager? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HARDWARE_CHANNEL)
        val nfc = NfcHardwareManager(this, channel)
        val camera = CameraQrManager(this)
        val capabilities = DeviceCapabilitiesManager(applicationContext)
        nfcManager = nfc
        cameraQrManager = camera
        capabilitiesManager = capabilities

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceCapabilities" -> result.success(capabilities.getCapabilitiesSnapshot())
                "getNfcStatus" -> result.success(nfc.getNfcStatus())
                "startNfcReader" -> result.success(nfc.startReaderMode())
                "stopNfcReader" -> {
                    nfc.stopReaderMode()
                    result.success(true)
                }
                "openNfcSettings" -> {
                    nfc.openNfcSettings()
                    result.success(true)
                }
                "checkCameraPermission" -> result.success(camera.checkCameraPermission())
                "requestCameraPermission" -> camera.requestCameraPermission(result)
                "scanQrCode" -> camera.scanQrCode(result)
                "openAppSettings" -> {
                    camera.openAppSettings()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        nfcManager?.handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        nfcManager?.handleIntent(intent)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        val handled = cameraQrManager?.onRequestPermissionsResult(
            requestCode,
            permissions,
            grantResults
        ) ?: false
        if (!handled) {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        }
    }

    override fun onPause() {
        nfcManager?.stopReaderMode()
        super.onPause()
    }
}
