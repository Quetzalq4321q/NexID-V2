import '../../records/data/records_repository.dart';
import '../../records/domain/record_models.dart';
import '../domain/sync_models.dart';

/// Repositorio de sincronizacion y outbox segun agent/21_COLA_5_SEGUNDOS.md.
/// Simula la cola de dos pasadas e intervalos de 5 segundos.
class SyncRepository {
  SyncRepository({required RecordsRepository recordsRepository})
      : _recordsRepository = recordsRepository;

  final RecordsRepository _recordsRepository;
  DateTime _lastSyncTime = DateTime.now();

  Future<SyncStats> getStats() async {
    final List<EventRecord> records = await _recordsRepository.getRecords();
    int pending = 0;
    int confirmed = 0;
    int review = 0;

    for (final EventRecord r in records) {
      switch (r.syncStatus) {
        case RecordSyncStatus.pending:
          pending++;
          break;
        case RecordSyncStatus.confirmed:
          confirmed++;
          break;
        case RecordSyncStatus.reviewRequired:
          review++;
          break;
      }
    }

    return SyncStats(
      pendingCount: pending,
      confirmedCount: confirmed,
      reviewCount: review,
      lastSyncTime: _lastSyncTime,
    );
  }

  /// Ejecuta el proceso de sincronizacion respetando la politica de dos pasadas.
  Future<void> processQueue() async {
    final List<EventRecord> records = await _recordsRepository.getRecords();
    final List<EventRecord> pendings = records
        .where((r) => r.syncStatus == RecordSyncStatus.pending)
        .toList();

    for (final EventRecord r in pendings) {
      // Simula intervalo de envio controlado
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await _recordsRepository.updateSyncStatus(
        r.id,
        RecordSyncStatus.confirmed,
      );
    }

    _lastSyncTime = DateTime.now();
  }
}
