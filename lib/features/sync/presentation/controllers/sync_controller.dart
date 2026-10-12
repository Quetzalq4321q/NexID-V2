import 'package:flutter/foundation.dart';
import '../../data/sync_repository.dart';
import '../../domain/sync_models.dart';

/// Controlador del proceso de sincronizacion y estado de la cola.
class SyncController extends ChangeNotifier {
  SyncController({required SyncRepository repository})
      : _repository = repository {
    refreshStats();
  }

  final SyncRepository _repository;
  SyncStats _stats = SyncStats(
    pendingCount: 0,
    confirmedCount: 0,
    reviewCount: 0,
    lastSyncTime: DateTime.now(),
  );
  SyncProcessState _state = SyncProcessState.idle;

  SyncStats get stats => _stats;
  SyncProcessState get state => _state;
  bool get isSyncing => _state == SyncProcessState.syncing;

  Future<void> refreshStats() async {
    _stats = await _repository.getStats();
    if (_stats.reviewCount > 0) {
      _state = SyncProcessState.reviewRequired;
    } else if (_stats.pendingCount > 0) {
      _state = SyncProcessState.hasPending;
    } else {
      _state = SyncProcessState.idle;
    }
    notifyListeners();
  }

  Future<void> syncNow() async {
    if (_state == SyncProcessState.syncing) return;

    _state = SyncProcessState.syncing;
    notifyListeners();

    await _repository.processQueue();
    await refreshStats();
  }
}
