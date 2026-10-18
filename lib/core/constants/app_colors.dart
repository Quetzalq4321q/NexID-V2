import 'package:flutter/material.dart';

/// Tokens de color oficiales de NexID segun agent/03_DISENO.md.
/// Colores planos sin degradados ni efectos neon.
/// Utiliza un unico azul institucional solido (#1D4ED8) como identidad central.
abstract final class AppColors {
  /// Unico azul primario solido institucional de NexID.
  static const Color primary = Color(0xFF1D4ED8);

  /// Variante luminosa de alto contraste para modo oscuro.
  static const Color primaryLuminous = Color(0xFF2563EB);

  /// Superficie de acento azul neutro claro institucional.
  static const Color surfaceAccent = Color(0xFFEFF6FF);

  /// Superficie de acento azul noche para modo oscuro.
  static const Color surfaceAccentDark = Color(0xFF172554);

  /// Fondo blanco principal.
  static const Color background = Color(0xFFFFFFFF);

  /// Superficie de tarjetas y contenedores.
  static const Color surface = Color(0xFFF9FAFB);

  /// Texto principal en modo claro.
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundario legible en modo claro.
  static const Color textSecondary = Color(0xFF4B5563);

  /// Bordes y separadores.
  static const Color border = Color(0xFFE5E7EB);

  /// Estados semanticos solidos y accesibles.
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
}
