/// Informacion de version interna y trazabilidad de compilacion de NexID.
abstract final class AppVersion {
  /// Version semantica actual (MAJOR.MINOR.PATCH)
  static const String version = '0.0.7';

  /// Numero secuencial de compilacion tecnica
  static const int build = 7;

  /// Cadena completa con prefijo y build
  static const String full = 'v0.0.7+7';

  /// Etiqueta visual para la interfaz
  static const String label = 'v0.0.7+7 (Compilacion Local)';
}
