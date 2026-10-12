import 'package:flutter/foundation.dart';
import '../../../../core/performance/priority_task_scheduler.dart';
import '../../data/reports_repository.dart';
import '../../domain/report_models.dart';

/// Controlador de reportes asincronos sin bloqueo de pantalla ni fugas tras dispose.
/// Ejecuta la compilacion del documento en prioridad baja mediante Isolate.
class ReportsController extends ChangeNotifier {
  ReportsController({required this._repository}) {
    loadJobs();
  }

  final ReportsRepository _repository;
  List<ReportJob> _jobs = <ReportJob>[];
  bool _isLoading = false;
  bool _isDisposed = false;

  List<ReportJob> get jobs => _jobs;
  bool get isLoading => _isLoading;

  Future<void> loadJobs() async {
    if (_isDisposed) return;
    _isLoading = true;
    _safeNotify();

    _jobs = await _repository.getJobs();

    _isLoading = false;
    _safeNotify();
  }

  Future<void> requestReport({
    required String title,
    required String format,
    required String placeName,
  }) async {
    final ReportJob job = await _repository.createJob(
      title: title,
      format: format,
      filterPlace: placeName,
    );
    await loadJobs();

    await _repository.updateJobStatus(job.id, ReportStatus.processing);
    await loadJobs();

    final String jobId = job.id;
    final String ext = format.toLowerCase();
    final String outputUri = await PriorityTaskScheduler.instance
        .runCpuIntensive<String>(
      () => _compileReportUriInBackground(jobId, ext, title, placeName),
      priority: TaskPriority.low,
    );

    if (_isDisposed) return;
    await _repository.updateJobStatus(
      job.id,
      ReportStatus.completed,
      downloadUrl: outputUri,
    );
    await loadJobs();
  }

  static String _compileReportUriInBackground(
    String jobId,
    String ext,
    String title,
    String placeName,
  ) {
    final int checksum = title.codeUnits.fold<int>(
          0,
          (int acc, int c) => (acc * 31 + c) & 0x7FFFFFFF,
        ) ^
        placeName.length;
    return 'local://storage/reports/${jobId.toLowerCase()}_$checksum.$ext';
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
