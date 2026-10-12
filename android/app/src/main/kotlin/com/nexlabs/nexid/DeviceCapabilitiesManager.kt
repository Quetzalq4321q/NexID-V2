package com.nexlabs.nexid

import android.app.ActivityManager
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.nfc.NfcAdapter
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.os.StatFs

/**
 * Gestor nativo de telemetria de hardware y estado del sistema operativo Android.
 *
 * Cachea las propiedades estaticas de hardware una sola vez por sesion y consulta
 * unicamente los indicadores dinamicos bajo demanda sin bloquear el hilo principal.
 */
class DeviceCapabilitiesManager(private val context: Context) {

    private val staticHardwareInfo: Map<String, Any?> by lazy {
        collectStaticCapabilities()
    }

    fun getCapabilitiesSnapshot(): Map<String, Any?> {
        val result = HashMap<String, Any?>(staticHardwareInfo)
        result.putAll(collectDynamicState())
        return result
    }

    private fun collectStaticCapabilities(): Map<String, Any?> {
        val activityManager =
            context.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
        val packageManager = context.packageManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager?.getMemoryInfo(memInfo)

        val totalRamMb = if (memInfo.totalMem > 0) {
            (memInfo.totalMem / (1024L * 1024L)).toInt()
        } else {
            null
        }
        val lowMemoryThresholdMb = if (memInfo.threshold > 0) {
            (memInfo.threshold / (1024L * 1024L)).toInt()
        } else {
            null
        }
        val processMaxHeapMb = (Runtime.getRuntime().maxMemory() / (1024L * 1024L)).toInt()
        val abis = Build.SUPPORTED_ABIS?.toList() ?: emptyList()
        val totalStorageMb = queryTotalStorageMb()
        val glEsVersion = activityManager?.deviceConfigurationInfo?.glEsVersion
        val supportsVulkan = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N &&
            packageManager.hasSystemFeature(PackageManager.FEATURE_VULKAN_HARDWARE_LEVEL)
        val hasNfc = packageManager.hasSystemFeature(PackageManager.FEATURE_NFC)

        return mapOf(
            "isRealAndroidTelemetry" to true,
            "totalRamMb" to totalRamMb,
            "lowMemoryThresholdMb" to lowMemoryThresholdMb,
            "isLowRamDevice" to (activityManager?.isLowRamDevice ?: false),
            "memoryClassMb" to activityManager?.memoryClass,
            "largeMemoryClassMb" to activityManager?.largeMemoryClass,
            "processMaxHeapMb" to processMaxHeapMb,
            "cpuArchitecture" to (abis.firstOrNull() ?: "unknown"),
            "supportedAbis" to abis,
            "processorCores" to Runtime.getRuntime().availableProcessors(),
            "hardwareBoard" to resolveHardwareBoard(),
            "totalStorageMb" to totalStorageMb,
            "androidRelease" to (Build.VERSION.RELEASE ?: "unknown"),
            "androidSdkInt" to Build.VERSION.SDK_INT,
            "openGlEsVersion" to (glEsVersion ?: "unknown"),
            "supportsVulkanHardware" to supportsVulkan,
            "hasNfcHardware" to hasNfc,
        )
    }

    private fun collectDynamicState(): Map<String, Any?> {
        val activityManager =
            context.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
        val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as? BatteryManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager?.getMemoryInfo(memInfo)

        val availableRamMb = if (memInfo.availMem > 0) {
            (memInfo.availMem / (1024L * 1024L)).toInt()
        } else {
            null
        }
        val runtime = Runtime.getRuntime()
        val allocatedHeapMb =
            ((runtime.totalMemory() - runtime.freeMemory()) / (1024L * 1024L)).toInt()
        val batteryPct = batteryManager?.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            ?.takeIf { it in 0..100 }
        val nfcAdapter = try {
            NfcAdapter.getDefaultAdapter(context)
        } catch (_: Exception) {
            null
        }
        val networkState = queryNetworkState()

        return mapOf(
            "availableRamMb" to availableRamMb,
            "isSystemLowMemory" to memInfo.lowMemory,
            "processAllocatedHeapMb" to allocatedHeapMb,
            "availableStorageMb" to queryAvailableStorageMb(),
            "isNfcEnabled" to (nfcAdapter?.isEnabled == true),
            "isPowerSaveMode" to (powerManager?.isPowerSaveMode == true),
            "batteryPercentage" to batteryPct,
            "thermalStatus" to resolveThermalStatus(powerManager),
            "hasActiveNetwork" to networkState.first,
            "connectionType" to networkState.second,
            "isMeteredNetwork" to networkState.third,
        )
    }

    private fun resolveHardwareBoard(): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val soc = Build.SOC_MODEL
            if (!soc.isNullOrBlank() && soc != Build.UNKNOWN) {
                return soc
            }
        }
        return Build.HARDWARE ?: "unknown"
    }

    private fun queryTotalStorageMb(): Int? {
        return try {
            val stat = StatFs(context.filesDir.absolutePath)
            (stat.totalBytes / (1024L * 1024L)).toInt()
        } catch (_: Exception) {
            null
        }
    }

    private fun queryAvailableStorageMb(): Int? {
        return try {
            val stat = StatFs(context.filesDir.absolutePath)
            (stat.availableBytes / (1024L * 1024L)).toInt()
        } catch (_: Exception) {
            null
        }
    }

    private fun resolveThermalStatus(powerManager: PowerManager?): String {
        if (powerManager == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return "unsupported"
        }
        return try {
            when (powerManager.currentThermalStatus) {
                PowerManager.THERMAL_STATUS_NONE -> "none"
                PowerManager.THERMAL_STATUS_LIGHT -> "light"
                PowerManager.THERMAL_STATUS_MODERATE -> "moderate"
                PowerManager.THERMAL_STATUS_SEVERE -> "severe"
                PowerManager.THERMAL_STATUS_CRITICAL -> "critical"
                PowerManager.THERMAL_STATUS_EMERGENCY -> "emergency"
                PowerManager.THERMAL_STATUS_SHUTDOWN -> "shutdown"
                else -> "unknown"
            }
        } catch (_: Exception) {
            "unsupported"
        }
    }

    private fun queryNetworkState(): Triple<Boolean, String, Boolean> {
        return try {
            val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
                ?: return Triple(false, "unknown", true)
            val network = cm.activeNetwork ?: return Triple(false, "none", false)
            val caps = cm.getNetworkCapabilities(network) ?: return Triple(false, "none", false)
            val hasInternet = caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
            val isMetered = !caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_NOT_METERED)
            val type = when {
                caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
                caps.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
                caps.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
                else -> "other"
            }
            Triple(hasInternet, type, isMetered)
        } catch (_: Exception) {
            Triple(false, "unknown", true)
        }
    }
}
