import 'package:flutter/foundation.dart';
import '../../data/reports_repository.dart';
import '../../domain/report_models.dart';

/// Controlador de reportes asincronos sin bloqueo de pantalla.
class ReportsController extends ChangeNotifier {
  ReportsController({required ReportsRepository repository})
      : _repository = repository {
    loadJobs();
  }

  final ReportsRepository _repository;
  List<ReportJob> _jobs = [];
  bool _isLoading = false;

  List<ReportJob> get jobs => _jobs;
  bool get isLoading => _isLoading;

  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    _jobs = await _repository.getJobs();

    _isLoading = false;
    notifyListeners();
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

    // Simulacion de ejecucion en background
    Future<void>.delayed(const Duration(seconds: 1), () async {
      await _repository.updateJobStatus(job.id, ReportStatus.processing);
      await loadJobs();

      await Future<void>.delayed(const Duration(seconds: 2));
      await _repository.updateJobStatus(
        job.id,
        ReportStatus.completed,
        downloadUrl: 'local://storage/reports/${job.id.toLowerCase()}.${format.toLowerCase()}',
      );
      await loadJobs();
    });
  }
}
