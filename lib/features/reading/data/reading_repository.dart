import '../domain/credential_models.dart';

/// Repositorio local de lectura y resolucion de credenciales segun agent/13_NFC_QR.md.
/// Resuelve de forma local simulando la politica del servidor:
/// - NFC: entrega ficha completa de campos autorizados.
/// - QR: entrega proyeccion parcial restringiendo datos sensibles.
class ReadingRepository {
  final Map<String, Map<String, dynamic>> _mockDatabase = {
    'CARD-NFC-8821': {
      'studentId': 'STU-1001',
      'studentCode': '2023-0149',
      'studentName': 'Ana Maria Morales Quispe',
      'career': 'Ingenieria de Sistemas',
      'faculty': 'Facultad de Ingenieria y Arquitectura',
      'documentNumber': '72418930',
      'status': 'Matriculado Regular',
      'allowedActions': ['Entrada', 'Salida', 'Control Regular'],
    },
    'CARD-NFC-9932': {
      'studentId': 'STU-1002',
      'studentCode': '2022-0812',
      'studentName': 'Mateo Alejandro Torres Castro',
      'career': 'Administracion de Empresas',
      'faculty': 'Facultad de Ciencias Economicas',
      'documentNumber': '71923014',
      'status': 'Matriculado Regular',
      'allowedActions': ['Entrada', 'Salida', 'Control Regular'],
    },
    'QR-TOKEN-4410': {
      'studentId': 'STU-1003',
      'studentCode': '2024-0055',
      'studentName': 'Lucia Jimena Mendoza Flores',
      'career': 'Derecho y Ciencias Politicas',
      'faculty': 'Facultad de Derecho',
      'documentNumber': '74102938',
      'status': 'Matriculado Regular',
      'allowedActions': ['Entrada', 'Control Basico'],
    },
  };

  /// Lista de credenciales de prueba para facilitar pruebas en Android Studio.
  List<String> get availableTestTokens => _mockDatabase.keys.toList();

  Future<ResolvedCredential> resolveCredential({
    required String token,
    required ReadingMedium medium,
    required String placeId,
  }) async {
    // Simulacion de latencia local
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final Map<String, dynamic> data = _mockDatabase[token] ??
        {
          'studentId': 'STU-GEN-${token.hashCode.abs() % 1000}',
          'studentCode': '2024-${token.hashCode.abs() % 9000}',
          'studentName': 'Estudiante Temporal ($token)',
          'career': 'Facultad General',
          'faculty': 'Sede Principal',
          'documentNumber': '70000000',
          'status': 'Activo',
          'allowedActions': ['Entrada', 'Control'],
        };

    // Politica server-side en local: QR nunca proyecta documento de identidad
    final bool isNfc = medium == ReadingMedium.nfc;

    return ResolvedCredential(
      token: token,
      medium: medium,
      visibility: isNfc
          ? ProjectionVisibility.full
          : ProjectionVisibility.partial,
      studentId: data['studentId'] as String,
      studentCode: data['studentCode'] as String,
      studentName: data['studentName'] as String,
      career: data['career'] as String,
      faculty: isNfc ? (data['faculty'] as String?) : null,
      documentNumber: isNfc ? (data['documentNumber'] as String?) : null,
      status: data['status'] as String,
      allowedActions: List<String>.from(data['allowedActions'] as List),
      resolvedAt: DateTime.now(),
    );
  }
}
