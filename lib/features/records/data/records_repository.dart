import '../../reading/domain/credential_models.dart';
import '../domain/record_models.dart';

/// Repositorio local de eventos registrados segun agent/20_SQLITE_LOCAL.md.
class RecordsRepository {
  final List<EventRecord> _records = <EventRecord>[
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
      attemptCount: 1,
      operatorName: 'Carlos Vega (op_puerta)',
      lastModifiedAt: DateTime.now().subtract(const Duration(minutes: 41)),
      relatedInfo: 'Tarjeta NFC UID 04:A1:20:01 · Facultad de Ingenieria',
      changeHistory: const <RecordChangeEntry>[
        RecordChangeEntry(
          timestampLabel: 'Hace 42 min',
          actor: 'Carlos Vega (Terminal PL-01)',
          action: 'Captura NFC y escritura en cola SQLite local (Pasada 1)',
        ),
        RecordChangeEntry(
          timestampLabel: 'Hace 41 min',
          actor: 'Motor Sync (2 pasadas / 5s)',
          action: 'Confirmacion remota recibida desde MariaDB (Pasada 2)',
        ),
      ],
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
      attemptCount: 0,
      operatorName: 'Elena Salazar (sup_biblio)',
      lastModifiedAt: DateTime.now().subtract(const Duration(minutes: 18)),
      relatedInfo: 'Lectura optica QR con proyeccion parcial restringida',
      changeHistory: const <RecordChangeEntry>[
        RecordChangeEntry(
          timestampLabel: 'Hace 18 min',
          actor: 'Elena Salazar (Terminal PL-02)',
          action: 'Registro local encolado en espera de barrido de 5s',
        ),
      ],
    ),
    EventRecord(
      id: 'REC-103',
      idempotencyKey: 'idem-rec-103',
      studentId: 'STU-1003',
      studentCode: '2024-0055',
      studentName: 'Lucia Jimena Mendoza Flores',
      placeId: 'PL-01',
      placeName: 'Puerta Principal - Acceso Central',
      eventType: EventType.salida,
      medium: ReadingMedium.nfc,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      syncStatus: RecordSyncStatus.confirmed,
      attemptCount: 1,
      operatorName: 'Carlos Vega (op_puerta)',
      lastModifiedAt: DateTime.now().subtract(const Duration(hours: 2)),
      relatedInfo: 'Salida autorizada tras tramite en Secretaria Academica',
      changeHistory: const <RecordChangeEntry>[
        RecordChangeEntry(
          timestampLabel: 'Hace 2 horas',
          actor: 'Carlos Vega (Terminal PL-01)',
          action: 'Salida registrada y confirmada en servidor central',
        ),
      ],
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
    String operatorName = 'Carlos Vega (op_puerta)',
  }) async {
    final int newIdNum = _records.length + 101;
    final DateTime now = DateTime.now();
    final EventRecord record = EventRecord(
      id: 'REC-$newIdNum',
      idempotencyKey: 'idem-uuid-${now.microsecondsSinceEpoch}',
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      placeId: placeId,
      placeName: placeName,
      eventType: eventType,
      medium: medium,
      timestamp: now,
      syncStatus: RecordSyncStatus.pending,
      operatorName: operatorName,
      lastModifiedAt: now,
      relatedInfo: 'Capturado en punto $placeName mediante ${medium.label}',
      changeHistory: <RecordChangeEntry>[
        RecordChangeEntry(
          timestampLabel: 'Reciente',
          actor: operatorName,
          action: 'Creacion local en SQLite Outbox (${eventType.label})',
        ),
      ],
    );

    _records.insert(0, record);
    return record;
  }

  Future<void> updateSyncStatus(String id, RecordSyncStatus status) async {
    final int index = _records.indexWhere((EventRecord r) => r.id == id);
    if (index != -1) {
      final EventRecord current = _records[index];
      _records[index] = current.copyWith(
        syncStatus: status,
        attemptCount: current.attemptCount + 1,
        lastModifiedAt: DateTime.now(),
        changeHistory: <RecordChangeEntry>[
          RecordChangeEntry(
            timestampLabel: 'Sincronizado',
            actor: 'Motor Outbox 5s',
            action: 'Cambio de estado a: ${status.label}',
          ),
          ...current.changeHistory,
        ],
      );
    }
  }
}
