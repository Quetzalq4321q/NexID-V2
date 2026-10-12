import 'dart:async';
import 'dart:collection';
import 'dart:isolate';
import 'package:flutter/widgets.dart';

/// Niveles de prioridad de ejecucion segun PRIORIDAD 0 (Seccion 3).
enum TaskPriority {
  /// Interaccion inmediata, lectura/validacion NFC, guardado local y navegacion.
  critical,

  /// Carga de listas visibles, consultas de pantalla activa y pestañas academicas.
  medium,

  /// Precarga de miniaturas, estadisticas secundarias y preparacion de PDF pesados.
  low,
}

class _QueuedJob<T> {
  _QueuedJob({
    required this.priority,
    required this.action,
    required this.completer,
  });

  final TaskPriority priority;
  final Future<T> Function() action;
  final Completer<T> completer;
}

/// Planificador cooperativo que prioriza operaciones criticas (NFC y UI)
/// sobre cargas secundarias y limita la concurrencia en procesadores lentos.
class PriorityTaskScheduler {
  PriorityTaskScheduler._();

  static final PriorityTaskScheduler instance = PriorityTaskScheduler._();

  final Queue<_QueuedJob<dynamic>> _mediumQueue = Queue<_QueuedJob<dynamic>>();
  final Queue<_QueuedJob<dynamic>> _lowQueue = Queue<_QueuedJob<dynamic>>();

  int _activeCriticalCount = 0;
  int _activeBackgroundCount = 0;
  int _maxConcurrentBackground = 1;
  int _completedCriticalTasks = 0;
  int _completedBackgroundTasks = 0;

  bool get hasActiveCriticalTask => _activeCriticalCount > 0;
  int get activeCriticalCount => _activeCriticalCount;
  int get activeBackgroundCount => _activeBackgroundCount;
  int get pendingQueueLength => _mediumQueue.length + _lowQueue.length;
  int get completedCriticalTasks => _completedCriticalTasks;
  int get completedBackgroundTasks => _completedBackgroundTasks;

  void configureMaxConcurrency(int maxConcurrent) {
    _maxConcurrentBackground = maxConcurrent < 1 ? 1 : maxConcurrent;
    _drainQueues();
  }

  /// Ejecuta de inmediato una tarea critica (ej. lectura NFC o guardado local)
  /// pausando el arranque de nuevas tareas de prioridad baja mientras dura.
  Future<T> runCritical<T>(Future<T> Function() action) async {
    _activeCriticalCount++;
    try {
      final T result = await action();
      _completedCriticalTasks++;
      return result;
    } finally {
      _activeCriticalCount--;
      if (_activeCriticalCount == 0) {
        _drainQueues();
      }
    }
  }

  /// Encola una tarea segun su prioridad sin bloquear el hilo principal.
  Future<T> schedule<T>({
    required TaskPriority priority,
    required Future<T> Function() action,
  }) {
    if (priority == TaskPriority.critical) {
      return runCritical(action);
    }

    final Completer<T> completer = Completer<T>();
    final _QueuedJob<T> job = _QueuedJob<T>(
      priority: priority,
      action: action,
      completer: completer,
    );

    if (priority == TaskPriority.medium) {
      _mediumQueue.add(job);
    } else {
      _lowQueue.add(job);
    }

    _drainQueues();
    return completer.future;
  }

  /// Ejecuta calculo intensivo de CPU en un Isolate secundario en produccion
  /// y mediante microtarea cooperativa cuando corre bajo FakeAsync (testWidgets).
  Future<R> runCpuIntensive<R>(
    R Function() computation, {
    TaskPriority priority = TaskPriority.low,
    bool forceIsolate = false,
  }) {
    return schedule<R>(
      priority: priority,
      action: () async {
        final bool inFakeAsync = !forceIsolate &&
            Zone.current.toString().contains('FakeAsync') ||
            (!forceIsolate && _isRunningInWidgetTestBinding());
        if (inFakeAsync) {
          return await Future<R>.microtask(computation);
        }
        try {
          return await Isolate.run(computation);
        } catch (_) {
          return computation();
        }
      },
    );
  }

  bool _isRunningInWidgetTestBinding() {
    try {
      final String bindingType =
          WidgetsBinding.instance.runtimeType.toString();
      return bindingType.contains('TestWidgetsFlutterBinding') ||
          bindingType.contains('AutomatedTestWidgetsFlutterBinding');
    } catch (_) {
      return false;
    }
  }

  void _drainQueues() {
    while (_activeBackgroundCount < _maxConcurrentBackground) {
      _QueuedJob<dynamic>? nextJob;
      if (_mediumQueue.isNotEmpty) {
        nextJob = _mediumQueue.removeFirst();
      } else if (_activeCriticalCount == 0 && _lowQueue.isNotEmpty) {
        nextJob = _lowQueue.removeFirst();
      }

      if (nextJob == null) break;
      _executeJob(nextJob);
    }
  }

  Future<void> _executeJob(_QueuedJob<dynamic> job) async {
    _activeBackgroundCount++;
    try {
      final dynamic result = await job.action();
      _completedBackgroundTasks++;
      if (!job.completer.isCompleted) {
        job.completer.complete(result);
      }
    } catch (error, stackTrace) {
      if (!job.completer.isCompleted) {
        job.completer.completeError(error, stackTrace);
      }
    } finally {
      _activeBackgroundCount--;
      _drainQueues();
    }
  }
}
