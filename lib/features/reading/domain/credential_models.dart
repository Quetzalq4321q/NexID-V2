/// Medio fisico de lectura segun agent/13_NFC_QR.md.
enum ReadingMedium {
  nfc('Lectura NFC (Ficha Completa)'),
  qr('Lectura QR (Proyeccion Parcial)');

  const ReadingMedium(this.label);
  final String label;
}

/// Nivel de visibilidad autorizado segun el medio y politica del servidor.
enum ProjectionVisibility {
  full('Completa'),
  partial('Parcial');

  const ProjectionVisibility(this.label);
  final String label;
}

/// Resultado de la resolucion de una credencial segun agent/15_API.md.
class ResolvedCredential {
  const ResolvedCredential({
    required this.token,
    required this.medium,
    required this.visibility,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.career,
    this.faculty,
    this.documentNumber,
    this.photoUrl,
    required this.status,
    required this.allowedActions,
    required this.resolvedAt,
  });

  final String token;
  final ReadingMedium medium;
  final ProjectionVisibility visibility;
  final String studentId;
  final String studentCode;
  final String studentName;
  final String career;
  final String? faculty;
  final String? documentNumber;
  final String? photoUrl;
  final String status;
  final List<String> allowedActions;
  final DateTime resolvedAt;

  bool get isFullProjection => visibility == ProjectionVisibility.full;
}
