import 'package:flutter/material.dart';

/// Tipografia estandar para NexID segun agent/03_DISENO.md.
/// Roboto como unica tipografia autorizada. Sin decoraciones superfluas.
/// No impone colores oscuros estaticos para garantizar adaptacion completa a Claro y Oscuro.
abstract final class AppTypography {
  static const String fontFamily = 'Roboto';

  /// Titulos principales (24 px).
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  /// Subtitulos y encabezados de seccion (18 px).
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
  );

  /// Titulos pequenos para tarjetas y elementos de lista (15 px).
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
  );

  /// Texto de cuerpo principal (16 px).
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Texto secundario (14 px).
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Texto de botones y acciones primarias (16 px).
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  /// Etiquetas tecnicas y de estado (12 px).
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
  );
}
