import 'package:flutter/painting.dart';

/// Perfiles de simulacion y operacion para dispositivos Android economicos
/// segun PRIORIDAD 0 (2 GB, 3 GB, 4 GB de RAM y condiciones adversas).
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
    for (final void Function() callback in List<void Function()>.from(_cleanupCallbacks)) {
      callback();
    }
  }
}
