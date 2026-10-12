import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografia estandar para NexID segun agent/03_DISENO.md.
/// Roboto como unica tipografia autorizada. Sin decoraciones superfluas.
abstract final class AppTypography {
  static const String fontFamily = 'Roboto';

  /// Titulos principales (24 px).
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  /// Subtitulos y encabezados de seccion (18 px).
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Texto de cuerpo principal (16 px).
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Texto secundario (14 px).
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  /// Texto de botones y acciones primarias (16 px).
  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
    letterSpacing: 0.2,
  );

  /// Etiquetas tecnicas y de estado (12 px).
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
