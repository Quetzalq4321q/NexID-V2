import 'package:flutter/painting.dart';
import '../platform/device_capabilities_models.dart';

/// Niveles internos de adaptacion inteligente de rendimiento (PRIORIDAD 0).
enum AdaptivePerformanceLevel {
  lightweight(
    'Rendimiento ligero',
    'Caches reducidas, sin animaciones costosas y 1 tarea secundaria maxima',
  ),
  balanced(
    'Rendimiento equilibrado',
    'Equilibrio entre consumo de RAM, carga progresiva y fluidez operativa',
  ),
  full(
    'Rendimiento completo',
    'Capacidad grafica y de cache ampliada con prioridad critica para NFC',
  );

  const AdaptivePerformanceLevel(this.label, this.description);

  final String label;
  final String description;

  DevicePerformanceProfile get defaultProfile {
    return switch (this) {
      AdaptivePerformanceLevel.lightweight =>
        DevicePerformanceProfile.ultraLowEnd2Gb,
      AdaptivePerformanceLevel.balanced => DevicePerformanceProfile.lowEnd3Gb,
      AdaptivePerformanceLevel.full => DevicePerformanceProfile.budgetMid4Gb,
    };
  }
}

/// Perfiles de presupuesto operativo y simulacion auditable (PRIORIDAD 0).
enum DevicePerformanceProfile {
  ultraLowEnd2Gb(
    'Gama baja extrema (2 GB RAM)',
    'Redmi 15C / Equivalente 2 GB · CPU lenta y recursos limitados',
  ),
  lowEnd3Gb(
    'Gama baja (3 GB RAM)',
    'Samsung Galaxy A13 · Almacenamiento interno lento',
  ),
  budgetMid4Gb(
    'Gama media economica (4 GB RAM)',
    'Samsung Galaxy A14 · Uso cotidiano con varias aplicaciones',
  ),
  adverseConditions(
    'Condiciones adversas (2-4 GB RAM)',
    'Red movil inestable y procesos en segundo plano',
  );

  const DevicePerformanceProfile(this.label, this.description);

  final String label;
  final String description;

  AdaptivePerformanceLevel get adaptiveLevel {
    return switch (this) {
      DevicePerformanceProfile.ultraLowEnd2Gb =>
        AdaptivePerformanceLevel.lightweight,
      DevicePerformanceProfile.adverseConditions =>
        AdaptivePerformanceLevel.lightweight,
      DevicePerformanceProfile.lowEnd3Gb => AdaptivePerformanceLevel.balanced,
      DevicePerformanceProfile.budgetMid4Gb => AdaptivePerformanceLevel.full,
    };
  }

  PerformanceBudget get budget {
    return switch (this) {
      DevicePerformanceProfile.ultraLowEnd2Gb => const PerformanceBudget(
          simulatedTotalRamMb: 2048,
          maxImageCacheCount: 20,
          maxImageCacheBytes: 8 * 1024 * 1024,
          maxHydratedStudentDetails: 3,
          listPageSize: 6,
          searchDebounceMs: 280,
          simulatedStorageLatencyMs: 25,
          simulatedNetworkJitterMs: 60,
          forceLightweightUi: true,
          maxConcurrentBackgroundTasks: 1,
        ),
      DevicePerformanceProfile.lowEnd3Gb => const PerformanceBudget(
          simulatedTotalRamMb: 3072,
          maxImageCacheCount: 35,
          maxImageCacheBytes: 14 * 1024 * 1024,
          maxHydratedStudentDetails: 5,
          listPageSize: 8,
          searchDebounceMs: 220,
          simulatedStorageLatencyMs: 18,
          simulatedNetworkJitterMs: 35,
          forceLightweightUi: true,
          maxConcurrentBackgroundTasks: 1,
        ),
      DevicePerformanceProfile.budgetMid4Gb => const PerformanceBudget(
          simulatedTotalRamMb: 4096,
          maxImageCacheCount: 50,
          maxImageCacheBytes: 24 * 1024 * 1024,
          maxHydratedStudentDetails: 8,
          listPageSize: 10,
          searchDebounceMs: 160,
          simulatedStorageLatencyMs: 10,
          simulatedNetworkJitterMs: 15,
          forceLightweightUi: false,
          maxConcurrentBackgroundTasks: 2,
        ),
      DevicePerformanceProfile.adverseConditions => const PerformanceBudget(
          simulatedTotalRamMb: 2560,
          maxImageCacheCount: 20,
          maxImageCacheBytes: 8 * 1024 * 1024,
          maxHydratedStudentDetails: 3,
          listPageSize: 6,
          searchDebounceMs: 300,
          simulatedStorageLatencyMs: 35,
          simulatedNetworkJitterMs: 140,
          forceLightweightUi: true,
          maxConcurrentBackgroundTasks: 1,
        ),
    };
  }

  /// Determina automaticamente el perfil optimo evaluando RAM total/disponible,
  /// heap del proceso, ahorro de bateria, estado termico, red y presion de RAM.
  static DevicePerformanceProfile resolveAutomaticProfile(
    DeviceCapabilitiesSnapshot capabilities, {
    int memoryPressureEvents = 0,
  }) {
    if (capabilities.isSeverelyMemoryConstrained || memoryPressureEvents >= 2) {
      return DevicePerformanceProfile.ultraLowEnd2Gb;
    }
    if (!capabilities.hasActiveNetwork &&
        (capabilities.isModeratelyConstrained ||
            capabilities.hasThermalOrPowerConstraint)) {
      return DevicePerformanceProfile.adverseConditions;
    }
    if (!capabilities.isRealAndroidTelemetry ||
        capabilities.totalRamMb == null) {
      return memoryPressureEvents > 0
          ? DevicePerformanceProfile.ultraLowEnd2Gb
          : DevicePerformanceProfile.lowEnd3Gb;
    }
    if (capabilities.isModeratelyConstrained &&
        capabilities.hasThermalOrPowerConstraint) {
      return DevicePerformanceProfile.ultraLowEnd2Gb;
    }
    if (capabilities.isModeratelyConstrained ||
        capabilities.hasThermalOrPowerConstraint ||
        capabilities.isStorageConstrained ||
        memoryPressureEvents == 1) {
      return DevicePerformanceProfile.lowEnd3Gb;
    }
    return DevicePerformanceProfile.budgetMid4Gb;
  }
}

/// Presupuesto estricto de memoria, paginacion y concurrencia por perfil.
class PerformanceBudget {
  const PerformanceBudget({
    required this.simulatedTotalRamMb,
    required this.maxImageCacheCount,
    required this.maxImageCacheBytes,
    required this.maxHydratedStudentDetails,
    required this.listPageSize,
    required this.searchDebounceMs,
    required this.simulatedStorageLatencyMs,
    required this.simulatedNetworkJitterMs,
    required this.forceLightweightUi,
    required this.maxConcurrentBackgroundTasks,
  });

  final int simulatedTotalRamMb;
  final int maxImageCacheCount;
  final int maxImageCacheBytes;
  final int maxHydratedStudentDetails;
  final int listPageSize;
  final int searchDebounceMs;
  final int simulatedStorageLatencyMs;
  final int simulatedNetworkJitterMs;
  final bool forceLightweightUi;
  final int maxConcurrentBackgroundTasks;
}

/// Guardian global de memoria RAM para aplicar limites de cache de imagenes
/// y liberar recursos temporales ante presion de memoria o segundo plano.
class DeviceMemoryGuard {
  DeviceMemoryGuard._();

  static final DeviceMemoryGuard instance = DeviceMemoryGuard._();
  final List<void Function()> _cleanupCallbacks = <void Function()>[];
  DevicePerformanceProfile _activeProfile = DevicePerformanceProfile.lowEnd3Gb;
  int _memoryCleanupCount = 0;

  DevicePerformanceProfile get activeProfile => _activeProfile;
  PerformanceBudget get currentBudget => _activeProfile.budget;
  int get memoryCleanupCount => _memoryCleanupCount;

  void applyProfile(DevicePerformanceProfile profile) {
    _activeProfile = profile;
    final PerformanceBudget budget = profile.budget;
    try {
      final ImageCache cache = PaintingBinding.instance.imageCache;
      cache.maximumSize = budget.maxImageCacheCount;
      cache.maximumSizeBytes = budget.maxImageCacheBytes;
    } catch (_) {
      // Ignorado si PaintingBinding aun no fue inicializado en test unitario puro.
    }
  }

  void registerTransientCacheCleanup(void Function() callback) {
    if (!_cleanupCallbacks.contains(callback)) {
      _cleanupCallbacks.add(callback);
    }
  }

  void unregisterTransientCacheCleanup(void Function() callback) {
    _cleanupCallbacks.remove(callback);
  }

  /// Libera caches temporales e imagenes en memoria sin tocar datos criticos
  /// ni registros pendientes de sincronizacion en SQLite outbox.
  void evictTransientMemory() {
    _memoryCleanupCount++;
    try {
      final ImageCache cache = PaintingBinding.instance.imageCache;
      cache.clear();
      cache.clearLiveImages();
    } catch (_) {
      // Seguro en entornos sin binding grafico activo.
    }
    for (final void Function() callback
        in List<void Function()>.from(_cleanupCallbacks)) {
      callback();
    }
  }
}
