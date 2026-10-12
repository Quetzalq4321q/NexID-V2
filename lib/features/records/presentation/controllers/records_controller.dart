import 'package:flutter/foundation.dart';
import '../../../reading/domain/credential_models.dart';
import '../../data/records_repository.dart';
import '../../domain/record_models.dart';

/// Criterios unificados para el desplegable de opciones y filtros de registros.
enum RecordFilterCriteria {
  all('Todos los registros'),
  pending('Solo pendientes'),
  confirmed('Solo confirmados'),
  reviewRequired('En revision requerida'),
  entrada('Solo ingresos (entradas)'),
  salida('Solo salidas');

  const RecordFilterCriteria(this.label);
  final String label;
}

/// Controlador para la gestion de registros y filtrado.
class RecordsController extends ChangeNotifier {
  RecordsController({required this._repository}) {
    loadRecords();
  }

  final RecordsRepository _repository;
  List<EventRecord> _records = [];
  bool _isLoading = false;
  RecordFilterCriteria _filterCriteria = RecordFilterCriteria.all;
  String? _placeFilter;
  bool _sortDescending = true;

  List<EventRecord> get records {
    final List<EventRecord> filtered = _records.where((r) {
      switch (_filterCriteria) {
        case RecordFilterCriteria.all:
          break;
        case RecordFilterCriteria.pending:
          if (r.syncStatus != RecordSyncStatus.pending) return false;
        case RecordFilterCriteria.confirmed:
          if (r.syncStatus != RecordSyncStatus.confirmed) return false;
        case RecordFilterCriteria.reviewRequired:
          if (r.syncStatus != RecordSyncStatus.reviewRequired) return false;
        case RecordFilterCriteria.entrada:
          if (r.eventType != EventType.entrada) return false;
        case RecordFilterCriteria.salida:
          if (r.eventType != EventType.salida) return false;
      }
      if (_placeFilter != null &&
          _placeFilter!.isNotEmpty &&
          r.placeId != _placeFilter) {
        return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) => _sortDescending
        ? b.timestamp.compareTo(a.timestamp)
        : a.timestamp.compareTo(b.timestamp));

    return filtered;
  }

  bool get isLoading => _isLoading;
  RecordFilterCriteria get filterCriteria => _filterCriteria;
  bool get sortDescending => _sortDescending;
  String? get placeFilter => _placeFilter;

  RecordSyncStatus? get statusFilter {
    return switch (_filterCriteria) {
      RecordFilterCriteria.pending => RecordSyncStatus.pending,
      RecordFilterCriteria.confirmed => RecordSyncStatus.confirmed,
      RecordFilterCriteria.reviewRequired => RecordSyncStatus.reviewRequired,
      _ => null,
    };
  }

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    _records = await _repository.getRecords();

    _isLoading = false;
    notifyListeners();
  }

  Future<EventRecord> createRecord({
    required String studentId,
    required String studentCode,
    required String studentName,
    required String placeId,
    required String placeName,
    required EventType eventType,
    required ReadingMedium medium,
  }) async {
    final EventRecord record = await _repository.addRecord(
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      placeId: placeId,
      placeName: placeName,
      eventType: eventType,
      medium: medium,
    );
    await loadRecords();
    return record;
  }

  void setFilterCriteria(RecordFilterCriteria criteria) {
    _filterCriteria = criteria;
    notifyListeners();
  }

  void toggleSortOrder() {
    _sortDescending = !_sortDescending;
    notifyListeners();
  }

  void setStatusFilter(RecordSyncStatus? filter) {
    _filterCriteria = switch (filter) {
      RecordSyncStatus.pending => RecordFilterCriteria.pending,
      RecordSyncStatus.confirmed => RecordFilterCriteria.confirmed,
      RecordSyncStatus.reviewRequired => RecordFilterCriteria.reviewRequired,
      null => RecordFilterCriteria.all,
    };
    notifyListeners();
  }

  void setPlaceFilter(String? placeId) {
    _placeFilter = placeId;
    notifyListeners();
  }
}
