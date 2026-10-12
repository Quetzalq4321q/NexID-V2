import '../../reading/domain/credential_models.dart';
import '../domain/record_models.dart';

/// Repositorio local de eventos registrados segun agent/20_SQLITE_LOCAL.md.
class RecordsRepository {
  final List<EventRecord> _records = [
    EventRecord(
      id: 'REC-101',
      idempotencyKey: 'idem-rec-101',
      studentId: 'STU-1001',
      studentCode: '2023-0149',
      studentName: 'Ana Maria Morales Quispe',
      placeId: 'PL-01',
      placeName: 'Puerta Principal - Acceso Central',
      eventType: EventType.entrada,
      medium: ReadingMedium.nfc,
      timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
      syncStatus: RecordSyncStatus.confirmed,
    ),
    EventRecord(
      id: 'REC-102',
      idempotencyKey: 'idem-rec-102',
      studentId: 'STU-1002',
      studentCode: '2022-0812',
      studentName: 'Mateo Alejandro Torres Castro',
      placeId: 'PL-02',
      placeName: 'Biblioteca Central',
      eventType: EventType.control,
      medium: ReadingMedium.qr,
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      syncStatus: RecordSyncStatus.pending,
    ),
  ];

  Future<List<EventRecord>> getRecords() async {
    return List<EventRecord>.unmodifiable(_records);
  }

  Future<EventRecord> addRecord({
    required String studentId,
    required String studentCode,
    required String studentName,
    required String placeId,
    required String placeName,
    required EventType eventType,
    required ReadingMedium medium,
  }) async {
    final int newIdNum = _records.length + 101;
    final EventRecord record = EventRecord(
      id: 'REC-$newIdNum',
      idempotencyKey: 'idem-uuid-${DateTime.now().microsecondsSinceEpoch}',
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      placeId: placeId,
      placeName: placeName,
      eventType: eventType,
      medium: medium,
      timestamp: DateTime.now(),
      syncStatus: RecordSyncStatus.pending,
    );

    _records.insert(0, record);
    return record;
  }

  Future<void> updateSyncStatus(String id, RecordSyncStatus status) async {
    final int index = _records.indexWhere((r) => r.id == id);
    if (index != -1) {
      _records[index] = _records[index].copyWith(syncStatus: status);
    }
  }
}
