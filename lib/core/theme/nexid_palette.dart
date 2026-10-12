import 'package:flutter/material.dart';

/// Sistema de tokens semanticos de color para modos Claro, Oscuro y Alto Contraste (WCAG 2.2).
/// Garantiza independencia visual completa entre apariencias sin fugas de color.
class NexIdPalette extends ThemeExtension<NexIdPalette> {
  const NexIdPalette({
    required this.isDark,
    required this.primary,
    required this.onPrimary,
    required this.surfaceAccent,
    required this.onSurfaceAccent,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.success,
    required this.warning,
    required this.error,
  });

  final bool isDark;
  final Color primary;
  final Color onPrimary;
  final Color surfaceAccent;
  final Color onSurfaceAccent;
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color skeletonBase;
  final Color skeletonHighlight;
  final Color success;
  final Color warning;
  final Color error;

  Color get surfaceSubtle =>
      isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6);
  Color get textDisabled => textSecondary.withAlpha(150);
  Color get successSurface => success.withAlpha(isDark ? 38 : 26);
  Color get warningSurface => warning.withAlpha(isDark ? 38 : 26);
  Color get errorSurface => error.withAlpha(isDark ? 38 : 26);

  static const NexIdPalette light = NexIdPalette(
    isDark: false,
    primary: Color(0xFF1D4ED8),
    onPrimary: Color(0xFFFFFFFF),
    surfaceAccent: Color(0xFFEFF6FF),
    onSurfaceAccent: Color(0xFF1E3A8A),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF9FAFB),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF4B5563),
    border: Color(0xFFE5E7EB),
    skeletonBase: Color(0xFFE5E7EB),
    skeletonHighlight: Color(0xFFF3F4F6),
    success: Color(0xFF059669),
    warning: Color(0xFFD97706),
    error: Color(0xFFDC2626),
  );

  static const NexIdPalette lightHighContrast = NexIdPalette(
    isDark: false,
    primary: Color(0xFF1E3A8A),
    onPrimary: Color(0xFFFFFFFF),
    surfaceAccent: Color(0xFFDBEAFE),
    onSurfaceAccent: Color(0xFF000000),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF3F4F6),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF1F2937),
    border: Color(0xFF374151),
    skeletonBase: Color(0xFFD1D5DB),
    skeletonHighlight: Color(0xFFE5E7EB),
    success: Color(0xFF047857),
    warning: Color(0xFFB45309),
    error: Color(0xFFB91C1C),
  );

  static const NexIdPalette dark = NexIdPalette(
    isDark: true,
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFFFFFFFF),
    surfaceAccent: Color(0xFF172554),
    onSurfaceAccent: Color(0xFFDBEAFE),
    background: Color(0xFF0B0F19),
    surface: Color(0xFF111827),
    surfaceElevated: Color(0xFF1E293B),
    textPrimary: Color(0xFFF9FAFB),
    textSecondary: Color(0xFF9CA3AF),
    border: Color(0xFF374151),
    skeletonBase: Color(0xFF1E293B),
    skeletonHighlight: Color(0xFF334155),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
  );

  static const NexIdPalette darkHighContrast = NexIdPalette(
    isDark: true,
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF000000),
    surfaceAccent: Color(0xFF1E3A8A),
    onSurfaceAccent: Color(0xFFFFFFFF),
    background: Color(0xFF000000),
    surface: Color(0xFF0F172A),
    surfaceElevated: Color(0xFF1E293B),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFE5E7EB),
    border: Color(0xFF9CA3AF),
    skeletonBase: Color(0xFF1E293B),
    skeletonHighlight: Color(0xFF475569),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
  );

  static NexIdPalette of(BuildContext context) {
    return Theme.of(context).extension<NexIdPalette>() ?? light;
  }

  @override
  NexIdPalette copyWith({
    bool? isDark,
    Color? primary,
    Color? onPrimary,
    Color? surfaceAccent,
    Color? onSurfaceAccent,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return NexIdPalette(
      isDark: isDark ?? this.isDark,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      surfaceAccent: surfaceAccent ?? this.surfaceAccent,
      onSurfaceAccent: onSurfaceAccent ?? this.onSurfaceAccent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }

  @override
  NexIdPalette lerp(ThemeExtension<NexIdPalette>? other, double t) {
    if (other is! NexIdPalette) return this;
    return NexIdPalette(
      isDark: t < 0.5 ? isDark : other.isDark,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      surfaceAccent: Color.lerp(surfaceAccent, other.surfaceAccent, t)!,
      onSurfaceAccent: Color.lerp(onSurfaceAccent, other.onSurfaceAccent, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight:
          Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
    );
  }
}
