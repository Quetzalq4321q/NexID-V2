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

/// Controlador para la gestion de registros con busqueda avanzada, KPIs,
/// estados de Skeleton Loading y paginacion progresiva.
class RecordsController extends ChangeNotifier {
  RecordsController({required this.repository}) {
    loadRecords();
  }

  static const int pageSize = 6;

  final RecordsRepository repository;
  List<EventRecord> _records = <EventRecord>[];
  bool _isLoading = false;
  String? _errorMessage;
  RecordFilterCriteria _filterCriteria = RecordFilterCriteria.all;
  String? _placeFilter;
  String _searchQuery = '';
  bool _sortDescending = true;
  int _visibleLimit = pageSize;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCachedData => _records.isNotEmpty;
  RecordFilterCriteria get filterCriteria => _filterCriteria;
  bool get sortDescending => _sortDescending;
  String? get placeFilter => _placeFilter;
  String get searchQuery => _searchQuery;

  int get totalCount => _records.length;
  int get confirmedCount => _records
      .where((EventRecord r) => r.syncStatus == RecordSyncStatus.confirmed)
      .length;
  int get pendingCount => _records
      .where((EventRecord r) => r.syncStatus == RecordSyncStatus.pending)
      .length;

  List<EventRecord> get records {
    final List<EventRecord> filtered = _records.where((EventRecord r) {
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
      if (_searchQuery.isNotEmpty) {
        final String q = _searchQuery.toLowerCase();
        final bool matches = r.id.toLowerCase().contains(q) ||
            r.studentName.toLowerCase().contains(q) ||
            r.studentCode.toLowerCase().contains(q) ||
            r.placeName.toLowerCase().contains(q) ||
            r.operatorName.toLowerCase().contains(q);
        if (!matches) return false;
      }
      return true;
    }).toList();

    filtered.sort((EventRecord a, EventRecord b) => _sortDescending
        ? b.timestamp.compareTo(a.timestamp)
        : a.timestamp.compareTo(b.timestamp));

    return filtered;
  }

  List<EventRecord> get paginatedRecords {
    final List<EventRecord> allFiltered = records;
    if (allFiltered.length <= _visibleLimit) return allFiltered;
    return allFiltered.take(_visibleLimit).toList();
  }

  bool get hasMorePages => records.length > _visibleLimit;

  void loadMore() {
    _visibleLimit += pageSize;
    notifyListeners();
  }

  RecordSyncStatus? get statusFilter {
    return switch (_filterCriteria) {
      RecordFilterCriteria.pending => RecordSyncStatus.pending,
      RecordFilterCriteria.confirmed => RecordSyncStatus.confirmed,
      RecordFilterCriteria.reviewRequired => RecordSyncStatus.reviewRequired,
      _ => null,
    };
  }

  Future<void> loadRecords({bool forceSkeleton = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (forceSkeleton) {
      _records = <EventRecord>[];
    }
    notifyListeners();

    try {
      if (forceSkeleton) {
        await Future<void>.delayed(const Duration(milliseconds: 450));
      }
      _records = await repository.getRecords();
    } catch (e) {
      _errorMessage = 'Error al consultar la cola SQLite local: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<EventRecord> createRecord({
    required String studentId,
    required String studentCode,
    required String studentName,
    required String placeId,
    required String placeName,
    required EventType eventType,
    required ReadingMedium medium,
    String operatorName = 'Carlos Vega (op_puerta)',
  }) async {
    final EventRecord record = await repository.addRecord(
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      placeId: placeId,
      placeName: placeName,
      eventType: eventType,
      medium: medium,
      operatorName: operatorName,
    );
    await loadRecords();
    return record;
  }

  void setFilterCriteria(RecordFilterCriteria criteria) {
    _filterCriteria = criteria;
    _visibleLimit = pageSize;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    _visibleLimit = pageSize;
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
    _visibleLimit = pageSize;
    notifyListeners();
  }

  void setPlaceFilter(String? placeId) {
    _placeFilter = placeId;
    _visibleLimit = pageSize;
    notifyListeners();
  }

  void clearFilters() {
    _filterCriteria = RecordFilterCriteria.all;
    _placeFilter = null;
    _searchQuery = '';
    _visibleLimit = pageSize;
    notifyListeners();
  }
}
