import 'package:flutter/material.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_typography.dart';
import '../core/theme/nexid_palette.dart';

/// Configuracion centralizada de temas Claro, Oscuro y Alto Contraste (WCAG 2.2).
abstract final class AppTheme {
  static ThemeData get lightTheme => buildTheme(NexIdPalette.light);
  static ThemeData get darkTheme => buildTheme(NexIdPalette.dark);

  static ThemeData light({bool highContrast = false}) {
    return buildTheme(
      highContrast ? NexIdPalette.lightHighContrast : NexIdPalette.light,
    );
  }

  static ThemeData dark({bool highContrast = false}) {
    return buildTheme(
      highContrast ? NexIdPalette.darkHighContrast : NexIdPalette.dark,
    );
  }

  static ThemeData buildTheme(NexIdPalette palette) {
    final Brightness brightness =
        palette.isDark ? Brightness.dark : Brightness.light;

    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      secondary: palette.surfaceAccent,
      onSecondary: palette.onSurfaceAccent,
      error: palette.error,
      onError: palette.onPrimary,
      surface: palette.surface,
      onSurface: palette.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTypography.fontFamily,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.surfaceElevated,
      cardColor: palette.surface,
      dividerColor: palette.border,
      primaryColor: palette.primary,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[palette],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.textPrimary),
        titleTextStyle: AppTypography.titleMedium.copyWith(
          color: palette.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(color: palette.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(color: palette.border),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: palette.surfaceElevated,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.surfaceAccent,
        iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: palette.onSurfaceAccent);
          }
          return IconThemeData(color: palette.textSecondary);
        }),
        labelTextStyle:
            WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool selected = states.contains(WidgetState.selected);
          return AppTypography.caption.copyWith(
            color: selected ? palette.textPrimary : palette.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.surfaceAccent,
        selectedIconTheme: IconThemeData(color: palette.onSurfaceAccent),
        unselectedIconTheme: IconThemeData(color: palette.textSecondary),
        selectedLabelTextStyle: AppTypography.caption.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelTextStyle: AppTypography.caption.copyWith(
          color: palette.textSecondary,
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.textSecondary,
        textColor: palette.textPrimary,
        subtitleTextStyle: AppTypography.caption.copyWith(
          color: palette.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          elevation: 0,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.textPrimary,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
          side: BorderSide(color: palette.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surface,
        hintStyle: AppTypography.bodySmall.copyWith(
          color: palette.textSecondary,
        ),
        labelStyle: AppTypography.bodySmall.copyWith(
          color: palette.textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMedium,
          vertical: 14.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          borderSide: BorderSide(color: palette.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          borderSide: BorderSide(color: palette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          borderSide: BorderSide(color: palette.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surface,
        selectedColor: palette.primary,
        side: BorderSide(color: palette.border),
        labelStyle: AppTypography.caption.copyWith(color: palette.textPrimary),
      ),
      dividerTheme: DividerThemeData(
        color: palette.border,
        thickness: 1,
      ),
      textTheme: TextTheme(
        headlineMedium: AppTypography.titleLarge.copyWith(
          color: palette.textPrimary,
        ),
        titleMedium: AppTypography.titleMedium.copyWith(
          color: palette.textPrimary,
        ),
        bodyLarge: AppTypography.bodyMedium.copyWith(
          color: palette.textPrimary,
        ),
        bodyMedium: AppTypography.bodySmall.copyWith(
          color: palette.textSecondary,
        ),
        bodySmall: AppTypography.caption.copyWith(
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
