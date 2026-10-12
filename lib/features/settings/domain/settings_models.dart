import 'package:flutter/material.dart';
import '../../reading/domain/credential_models.dart';

/// Opciones de preferencia de apariencia (Claro, Oscuro, Automatico).
enum AppThemePreference {
  system('Automatico', 'Sigue el tema del sistema operativo'),
  light('Claro', 'Superficies claras de alto contraste diurno'),
  dark('Oscuro', 'Superficies oscuras para baja iluminacion');

  const AppThemePreference(this.label, this.description);

  final String label;
  final String description;

  ThemeMode get toThemeMode {
    return switch (this) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }
}

/// Niveles de escala tipografica conforme a WCAG 2.2.
enum FontScalePreset {
  compact(0.90, '90%', 'Compacto'),
  normal(1.00, '100%', 'Estandar'),
  large(1.15, '115%', 'Grande'),
  extraLarge(1.30, '130%', 'Extra grande');

  const FontScalePreset(this.scaleFactor, this.percentageLabel, this.label);

  final double scaleFactor;
  final String percentageLabel;
  final String label;
}

/// Configuracion operativa, de apariencia y accesibilidad del terminal.
class AppSettings {
  const AppSettings({
    this.themePreference = AppThemePreference.system,
    this.fontScalePreset = FontScalePreset.normal,
    this.highContrast = false,
    this.reduceMotion = false,
    this.screenReaderOptimized = false,
    this.preferredMedium = ReadingMedium.nfc,
    this.vibrateOnScan = true,
    this.soundOnScan = true,
    this.simulateOffline = false,
    this.syncIntervalSeconds = 5,
  });

  final AppThemePreference themePreference;
  final FontScalePreset fontScalePreset;
  final bool highContrast;
  final bool reduceMotion;
  final bool screenReaderOptimized;
  final ReadingMedium preferredMedium;
  final bool vibrateOnScan;
  final bool soundOnScan;
  final bool simulateOffline;
  final int syncIntervalSeconds;

  AppSettings copyWith({
    AppThemePreference? themePreference,
    FontScalePreset? fontScalePreset,
    bool? highContrast,
    bool? reduceMotion,
    bool? screenReaderOptimized,
    ReadingMedium? preferredMedium,
    bool? vibrateOnScan,
    bool? soundOnScan,
    bool? simulateOffline,
    int? syncIntervalSeconds,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      fontScalePreset: fontScalePreset ?? this.fontScalePreset,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      screenReaderOptimized:
          screenReaderOptimized ?? this.screenReaderOptimized,
      preferredMedium: preferredMedium ?? this.preferredMedium,
      vibrateOnScan: vibrateOnScan ?? this.vibrateOnScan,
      soundOnScan: soundOnScan ?? this.soundOnScan,
      simulateOffline: simulateOffline ?? this.simulateOffline,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themePreference': themePreference.name,
      'fontScalePreset': fontScalePreset.name,
      'highContrast': highContrast,
      'reduceMotion': reduceMotion,
      'screenReaderOptimized': screenReaderOptimized,
      'preferredMedium': preferredMedium.name,
      'vibrateOnScan': vibrateOnScan,
      'soundOnScan': soundOnScan,
      'simulateOffline': simulateOffline,
      'syncIntervalSeconds': syncIntervalSeconds,
    };
  }
}
