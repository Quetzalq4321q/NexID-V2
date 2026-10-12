/// Estado del trabajo en segundo plano para reportes segun agent/15_API.md.
enum ReportStatus {
  queued('En cola'),
  processing('Generando archivo'),
  completed('Listo para descarga'),
  failed('Fallo');

  const ReportStatus(this.label);
  final String label;
}

/// Trabajo asincrono de reporte sin bloqueo de interfaz.
class ReportJob {
  const ReportJob({
    required this.id,
    required this.title,
    required this.format,
    required this.filterPlace,
    required this.status,
    required this.createdAt,
    this.downloadUrl,
  });

  final String id;
  final String title;
  final String format; // 'PDF' o 'CSV'
  final String filterPlace;
  final ReportStatus status;
  final DateTime createdAt;
  final String? downloadUrl;

  ReportJob copyWith({
    ReportStatus? status,
    String? downloadUrl,
  }) {
    return ReportJob(
      id: id,
      title: title,
      format: format,
      filterPlace: filterPlace,
      status: status ?? this.status,
      createdAt: createdAt,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}
