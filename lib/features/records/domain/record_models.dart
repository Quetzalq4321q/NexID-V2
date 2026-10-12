import '../../reading/domain/credential_models.dart';

/// Tipos de evento admitidos segun agent/04_PRODUCTO.md.
enum EventType {
  entrada('Ingreso'),
  salida('Salida'),
  control('Control');

  const EventType(this.label);
  final String label;
}

/// Estado de sincronizacion segun agent/21_COLA_5_SEGUNDOS.md.
enum RecordSyncStatus {
  pending('Pendiente de enviar'),
  confirmed('Confirmado por servidor'),
  reviewRequired('Requiere revision');

  const RecordSyncStatus(this.label);
  final String label;
}

/// Registro durable de un evento de control o asistencia.
class EventRecord {
  const EventRecord({
    required this.id,
    required this.idempotencyKey,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.placeId,
    required this.placeName,
    required this.eventType,
    required this.medium,
    required this.timestamp,
    required this.syncStatus,
    this.attemptCount = 0,
  });

  final String id;
  final String idempotencyKey;
  final String studentId;
  final String studentCode;
  final String studentName;
  final String placeId;
  final String placeName;
  final EventType eventType;
  final ReadingMedium medium;
  final DateTime timestamp;
  final RecordSyncStatus syncStatus;
  final int attemptCount;

  EventRecord copyWith({
    RecordSyncStatus? syncStatus,
    int? attemptCount,
  }) {
    return EventRecord(
      id: id,
      idempotencyKey: idempotencyKey,
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      placeId: placeId,
      placeName: placeName,
      eventType: eventType,
      medium: medium,
      timestamp: timestamp,
      syncStatus: syncStatus ?? this.syncStatus,
      attemptCount: attemptCount ?? this.attemptCount,
    );
  }
}
