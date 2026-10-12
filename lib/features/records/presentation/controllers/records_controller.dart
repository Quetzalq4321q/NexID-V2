import 'package:flutter/foundation.dart';
import '../../../reading/domain/credential_models.dart';
import '../../data/records_repository.dart';
import '../../domain/record_models.dart';

/// Controlador para la gestion de registros y filtrado.
class RecordsController extends ChangeNotifier {
  RecordsController({required RecordsRepository repository})
      : _repository = repository {
    loadRecords();
  }

  final RecordsRepository _repository;
  List<EventRecord> _records = [];
  bool _isLoading = false;
  RecordSyncStatus? _statusFilter;
  String? _placeFilter;

  List<EventRecord> get records {
    return _records.where((r) {
      if (_statusFilter != null && r.syncStatus != _statusFilter) {
        return false;
      }
      if (_placeFilter != null &&
          _placeFilter!.isNotEmpty &&
          r.placeId != _placeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  bool get isLoading => _isLoading;
  RecordSyncStatus? get statusFilter => _statusFilter;
  String? get placeFilter => _placeFilter;

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

  void setStatusFilter(RecordSyncStatus? filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setPlaceFilter(String? placeId) {
    _placeFilter = placeId;
    notifyListeners();
  }
}
