/// Informacion de version interna y trazabilidad de compilacion de NexID.
abstract final class AppVersion {
  /// Version semantica actual (MAJOR.MINOR.PATCH)
  static const String version = '0.0.4';

  /// Numero secuencial de compilacion tecnica
  static const int build = 4;

  /// Cadena completa con prefijo y build
  static const String full = 'v0.0.4+4';

  /// Etiqueta visual para la interfaz
  static const String label = 'v0.0.4+4 (Compilacion Local)';
}
