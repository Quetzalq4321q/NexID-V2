/// Dimensiones y espaciados estandar segun agent/03_DISENO.md.
abstract final class AppDimensions {
  /// Espaciados oficiales.
  static const double spaceXSmall = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceExtraLarge = 32.0;
  static const double spaceXLarge = spaceExtraLarge;

  /// Radio estandar de esquinas.
  static const double radius = 12.0;

  /// Altura minima de controles tactiles accesibles.
  static const double minTouchTarget = 48.0;

  /// Breakpoints para diseno responsivo (agent/08_ADAPTABILIDAD.md).
  static const double breakpointMedium = 600.0;
  static const double breakpointLarge = 840.0;
}
