import 'package:flutter/material.dart';

/// Tokens de color oficiales de NexID segun agent/03_DISENO.md.
/// Colores planos sin degradados ni efectos neon.
abstract final class AppColors {
  /// Azul primario solido.
  static const Color primary = Color(0xFF1D4ED8);

  /// Superficie de acento azul neutro claro (sin acentos morados).
  /// IMPORTANTE: Utilizar siempre con texto oscuro, nunca texto blanco.
  static const Color surfaceAccent = Color(0xFFDBEAFE);

  /// Fondo blanco principal.
  static const Color background = Color(0xFFFFFFFF);

  /// Superficie de tarjetas y contenedores.
  static const Color surface = Color(0xFFF9FAFB);

  /// Texto principal.
  static const Color textPrimary = Color(0xFF111827);

  /// Texto secundario legible.
  static const Color textSecondary = Color(0xFF4B5563);

  /// Bordes y separadores.
  static const Color border = Color(0xFFE5E7EB);

  /// Estados semanticos solidos y accesibles.
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color error = Color(0xFFDC2626);
}
