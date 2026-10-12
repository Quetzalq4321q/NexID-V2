package com.nexlabs.nexid

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import com.google.mlkit.vision.barcode.common.Barcode
import com.google.mlkit.vision.codescanner.GmsBarcodeScannerOptions
import com.google.mlkit.vision.codescanner.GmsBarcodeScanning
import io.flutter.plugin.common.MethodChannel

/**
 * Gestor nativo en Kotlin para permisos de camara en tiempo de ejecucion y escaneo QR.
 */
class CameraQrManager(
    private val activity: Activity
) {
    companion object {
        const val REQUEST_CAMERA_PERMISSION = 4102
    }

    private var pendingPermissionResult: MethodChannel.Result? = null

    fun checkCameraPermission(): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return "granted"
        }
        val granted = activity.checkSelfPermission(Manifest.permission.CAMERA) ==
                PackageManager.PERMISSION_GRANTED
        return if (granted) "granted" else "denied"
    }

    fun requestCameraPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            result.success("granted")
            return
        }
        if (activity.checkSelfPermission(Manifest.permission.CAMERA) ==
            PackageManager.PERMISSION_GRANTED
        ) {
            result.success("granted")
            return
        }
        pendingPermissionResult = result
        activity.requestPermissions(
            arrayOf(Manifest.permission.CAMERA),
            REQUEST_CAMERA_PERMISSION
        )
    }

    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        if (requestCode != REQUEST_CAMERA_PERMISSION) return false
        val pending = pendingPermissionResult ?: return true
        pendingPermissionResult = null

        if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            pending.success("granted")
        } else {
            val shouldShowRationale = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
                permissions.isNotEmpty()
            ) {
                activity.shouldShowRequestPermissionRationale(permissions[0])
            } else {
                true
            }
            pending.success(if (shouldShowRationale) "denied" else "permanently_denied")
        }
        return true
    }

    fun scanQrCode(result: MethodChannel.Result) {
        val options = GmsBarcodeScannerOptions.Builder()
            .setBarcodeFormats(Barcode.FORMAT_QR_CODE)
            .enableAutoZoom()
            .build()

        val scanner = GmsBarcodeScanning.getClient(activity, options)
        scanner.startScan()
            .addOnSuccessListener { barcode ->
                val rawValue = barcode.rawValue?.trim()
                if (!rawValue.isNullOrEmpty()) {
                    result.success(rawValue)
                } else {
                    result.error("EMPTY_QR", "El codigo QR escaneado no contiene datos.", null)
                }
            }
            .addOnCanceledListener {
                result.success(null)
            }
            .addOnFailureListener { e ->
                result.error(
                    "QR_SCAN_ERROR",
                    e.localizedMessage ?: "No se pudo iniciar el escaneo optico QR.",
                    null
                )
            }
    }

    fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.fromParts("package", activity.packageName, null)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        activity.startActivity(intent)
    }
}
