/// Instantanea inmutable de las capacidades reales de hardware y estado
/// dinamico del sistema operativo Android (PRIORIDAD 0).
///
/// No inventa valores cuando el sistema operativo no los reporta (`null`) y
/// evalua restricciones reales del proceso y memoria en lugar del nombre comercial.
class DeviceCapabilitiesSnapshot {
  const DeviceCapabilitiesSnapshot({
    required this.isRealAndroidTelemetry,
    this.totalRamMb,
    this.availableRamMb,
    this.lowMemoryThresholdMb,
    this.isLowRamDevice = false,
    this.isSystemLowMemory = false,
    this.memoryClassMb,
    this.largeMemoryClassMb,
    this.processMaxHeapMb,
    this.processAllocatedHeapMb,
    this.cpuArchitecture = 'unknown',
    this.supportedAbis = const <String>[],
    this.processorCores,
    this.hardwareBoard = 'unknown',
    this.totalStorageMb,
    this.availableStorageMb,
    this.androidRelease = 'unknown',
    this.androidSdkInt,
    this.openGlEsVersion = 'unknown',
    this.supportsVulkanHardware = false,
    this.hasNfcHardware = true,
    this.isNfcEnabled = true,
    this.isPowerSaveMode = false,
    this.batteryPercentage,
    this.thermalStatus = 'unsupported',
    this.hasActiveNetwork = true,
    this.connectionType = 'unknown',
    this.isMeteredNetwork = false,
  });

  /// Respaldo seguro cuando el canal nativo no responde o no expone datos.
  /// Nunca inventa cifras de RAM ni almacenamiento (`null`).
  factory DeviceCapabilitiesSnapshot.fallbackWhenUnavailable() {
    return const DeviceCapabilitiesSnapshot(
      isRealAndroidTelemetry: false,
    );
  }

  factory DeviceCapabilitiesSnapshot.fromMap(Map<dynamic, dynamic> map) {
    final List<String> abis = (map['supportedAbis'] as List<dynamic>?)
            ?.map((dynamic e) => e.toString())
            .toList() ??
        const <String>[];
    return DeviceCapabilitiesSnapshot(
      isRealAndroidTelemetry: (map['isRealAndroidTelemetry'] as bool?) ?? true,
      totalRamMb: _asPositiveInt(map['totalRamMb']),
      availableRamMb: _asPositiveInt(map['availableRamMb']),
      lowMemoryThresholdMb: _asPositiveInt(map['lowMemoryThresholdMb']),
      isLowRamDevice: (map['isLowRamDevice'] as bool?) ?? false,
      isSystemLowMemory: (map['isSystemLowMemory'] as bool?) ?? false,
      memoryClassMb: _asPositiveInt(map['memoryClassMb']),
      largeMemoryClassMb: _asPositiveInt(map['largeMemoryClassMb']),
      processMaxHeapMb: _asPositiveInt(map['processMaxHeapMb']),
      processAllocatedHeapMb: _asNonNegativeInt(map['processAllocatedHeapMb']),
      cpuArchitecture: _asNonEmptyString(map['cpuArchitecture']),
      supportedAbis: abis,
      processorCores: _asPositiveInt(map['processorCores']),
      hardwareBoard: _asNonEmptyString(map['hardwareBoard']),
      totalStorageMb: _asPositiveInt(map['totalStorageMb']),
      availableStorageMb: _asNonNegativeInt(map['availableStorageMb']),
      androidRelease: _asNonEmptyString(map['androidRelease']),
      androidSdkInt: _asPositiveInt(map['androidSdkInt']),
      openGlEsVersion: _asNonEmptyString(map['openGlEsVersion']),
      supportsVulkanHardware: (map['supportsVulkanHardware'] as bool?) ?? false,
      hasNfcHardware: (map['hasNfcHardware'] as bool?) ?? false,
      isNfcEnabled: (map['isNfcEnabled'] as bool?) ?? false,
      isPowerSaveMode: (map['isPowerSaveMode'] as bool?) ?? false,
      batteryPercentage: _asBatteryInt(map['batteryPercentage']),
      thermalStatus: _asNonEmptyString(
        map['thermalStatus'],
        fallback: 'unsupported',
      ),
      hasActiveNetwork: (map['hasActiveNetwork'] as bool?) ?? false,
      connectionType: _asNonEmptyString(map['connectionType']),
      isMeteredNetwork: (map['isMeteredNetwork'] as bool?) ?? true,
    );
  }

  final bool isRealAndroidTelemetry;
  final int? totalRamMb;
  final int? availableRamMb;
  final int? lowMemoryThresholdMb;
  final bool isLowRamDevice;
  final bool isSystemLowMemory;
  final int? memoryClassMb;
  final int? largeMemoryClassMb;
  final int? processMaxHeapMb;
  final int? processAllocatedHeapMb;
  final String cpuArchitecture;
  final List<String> supportedAbis;
  final int? processorCores;
  final String hardwareBoard;
  final int? totalStorageMb;
  final int? availableStorageMb;
  final String androidRelease;
  final int? androidSdkInt;
  final String openGlEsVersion;
  final bool supportsVulkanHardware;
  final bool hasNfcHardware;
  final bool isNfcEnabled;
  final bool isPowerSaveMode;
  final int? batteryPercentage;
  final String thermalStatus;
  final bool hasActiveNetwork;
  final String connectionType;
  final bool isMeteredNetwork;

  /// Detecta si el dispositivo tiene memoria severamente limitada (<= 2.5 GB total,
  /// indicador Android Go `isLowRamDevice`, presion activa o heap <= 192 MB).
  bool get isSeverelyMemoryConstrained {
    if (isLowRamDevice || isSystemLowMemory) return true;
    if (totalRamMb != null && totalRamMb! <= 2560) return true;
    if (availableRamMb != null && availableRamMb! <= 450) return true;
    if (processMaxHeapMb != null && processMaxHeapMb! <= 160) return true;
    return false;
  }

  /// Detecta si el dispositivo pertenece a gama economica (<= 3.8 GB total,
  /// disponible <= 900 MB, 4 nucleos o menos, o heap <= 256 MB).
  bool get isModeratelyConstrained {
    if (isSeverelyMemoryConstrained) return true;
    if (totalRamMb != null && totalRamMb! <= 3890) return true;
    if (availableRamMb != null && availableRamMb! <= 900) return true;
    if (processorCores != null && processorCores! <= 4) return true;
    if (processMaxHeapMb != null && processMaxHeapMb! <= 256) return true;
    return false;
  }

  /// Detecta si el ahorro de bateria o estado termico aconseja reducir carga.
  bool get hasThermalOrPowerConstraint {
    if (isPowerSaveMode) return true;
    return thermalStatus == 'moderate' ||
        thermalStatus == 'severe' ||
        thermalStatus == 'critical' ||
        thermalStatus == 'emergency';
  }

  /// Detecta si el almacenamiento libre es bajo (< 512 MB).
  bool get isStorageConstrained =>
      availableStorageMb != null && availableStorageMb! < 512;

  String get totalRamLabel => totalRamMb != null
      ? '$totalRamMb MB (~${(totalRamMb! / 1024).toStringAsFixed(1)} GB)'
      : 'No reportada por el SO';

  String get availableRamLabel => availableRamMb != null
      ? '$availableRamMb MB libres'
      : 'No reportada por el SO';

  String get storageAvailableLabel => availableStorageMb != null
      ? '$availableStorageMb MB disponibles'
      : 'No reportado por el SO';

  String get processorSummaryLabel {
    final String cores =
        processorCores != null ? '$processorCores nucleos' : 'Nucleos N/D';
    final String arch =
        cpuArchitecture != 'unknown' ? cpuArchitecture : 'Arquitectura N/D';
    return '$arch · $cores';
  }

  String get androidVersionLabel => androidSdkInt != null
      ? 'Android $androidRelease (API $androidSdkInt)'
      : 'Android (version no expuesta)';

  static int? _asPositiveInt(dynamic v) {
    if (v is int && v > 0) return v;
    if (v is num && v > 0) return v.toInt();
    return null;
  }

  static int? _asNonNegativeInt(dynamic v) {
    if (v is int && v >= 0) return v;
    if (v is num && v >= 0) return v.toInt();
    return null;
  }

  static int? _asBatteryInt(dynamic v) {
    if (v is int && v >= 0 && v <= 100) return v;
    return null;
  }

  static String _asNonEmptyString(dynamic v, {String fallback = 'unknown'}) {
    if (v is String && v.trim().isNotEmpty) return v.trim();
    return fallback;
  }
}
