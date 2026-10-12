import '../domain/report_models.dart';

/// Repositorio local para la generacion y consulta de reportes en segundo plano.
class ReportsRepository {
  final List<ReportJob> _jobs = [
    ReportJob(
      id: 'REP-501',
      title: 'Consolidado Diario de Ingresos',
      format: 'PDF',
      filterPlace: 'Puerta Principal - Acceso Central',
      status: ReportStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      downloadUrl: 'local://storage/reports/rep-501.pdf',
    ),
  ];

  Future<List<ReportJob>> getJobs() async {
    return List<ReportJob>.unmodifiable(_jobs);
  }

  Future<ReportJob> createJob({
    required String title,
    required String format,
    required String filterPlace,
  }) async {
    final int newNum = _jobs.length + 501;
    final ReportJob job = ReportJob(
      id: 'REP-$newNum',
      title: title,
      format: format,
      filterPlace: filterPlace,
      status: ReportStatus.queued,
      createdAt: DateTime.now(),
    );
    _jobs.insert(0, job);
    return job;
  }

  Future<void> updateJobStatus(
    String id,
    ReportStatus status, {
    String? downloadUrl,
  }) async {
    final int index = _jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      _jobs[index] = _jobs[index].copyWith(
        status: status,
        downloadUrl: downloadUrl,
      );
    }
  }
}
