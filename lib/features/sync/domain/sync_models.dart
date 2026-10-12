/// Estado del coordinador de sincronizacion segun agent/21_COLA_5_SEGUNDOS.md.
enum SyncProcessState {
  idle('Al dia'),
  syncing('Enviando cola (5s intervalo)'),
  hasPending('Cargas pendientes'),
  reviewRequired('Revision manual requerida');

  const SyncProcessState(this.label);
  final String label;
}

/// Metricas durables de la cola local segun agent/23_CACHE_USABLE.md.
class SyncStats {
  const SyncStats({
    required this.pendingCount,
    required this.confirmedCount,
    required this.reviewCount,
    required this.lastSyncTime,
  });

  final int pendingCount;
  final int confirmedCount;
  final int reviewCount;
  final DateTime lastSyncTime;
}
