import 'package:flutter/material.dart';
import '../../../../core/performance/device_performance_tier.dart';
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

/// Clasificacion de capas de configuracion (Usuario, Automatico, Avanzado, Protegido).
enum SettingLayerType {
  user('Ajuste del usuario'),
  automatic('Ajuste automatico'),
  advanced('Ajuste avanzado restringido'),
  protectedPolicy('Politica protegida inmutable');

  const SettingLayerType(this.label);
  final String label;
}

/// Configuracion operativa, de apariencia, accesibilidad y rendimiento (Prioridad 0).
///
/// Por defecto `isAutoPerformance = true` para que la aplicacion se adapte
/// automaticamente al hardware real sin intervencion manual del usuario.
class AppSettings {
  const AppSettings({
    this.themePreference = AppThemePreference.system,
    this.compactDensity = false,
    this.fontScalePreset = FontScalePreset.normal,
    this.highContrast = false,
    this.reduceMotion = false,
    this.screenReaderOptimized = false,
    this.isAutoPerformance = true,
    this.deviceProfile = DevicePerformanceProfile.lowEnd3Gb,
    this.lowPerformanceMode = true,
    this.dataSaverMode = false,
    this.preferredMedium = ReadingMedium.nfc,
    this.vibrateOnScan = true,
    this.soundOnScan = true,
    this.operationalAlertsEnabled = true,
    this.syncQueueAlertsEnabled = true,
    this.simulateOffline = false,
    this.syncIntervalSeconds = 5,
  });

  final AppThemePreference themePreference;
  final bool compactDensity;
  final FontScalePreset fontScalePreset;
  final bool highContrast;
  final bool reduceMotion;
  final bool screenReaderOptimized;
  final bool isAutoPerformance;
  final DevicePerformanceProfile deviceProfile;
  final bool lowPerformanceMode;
  final bool dataSaverMode;
  final ReadingMedium preferredMedium;
  final bool vibrateOnScan;
  final bool soundOnScan;
  final bool operationalAlertsEnabled;
  final bool syncQueueAlertsEnabled;
  final bool simulateOffline;
  final int syncIntervalSeconds;

  AppSettings copyWith({
    AppThemePreference? themePreference,
    bool? compactDensity,
    FontScalePreset? fontScalePreset,
    bool? highContrast,
    bool? reduceMotion,
    bool? screenReaderOptimized,
    bool? isAutoPerformance,
    DevicePerformanceProfile? deviceProfile,
    bool? lowPerformanceMode,
    bool? dataSaverMode,
    ReadingMedium? preferredMedium,
    bool? vibrateOnScan,
    bool? soundOnScan,
    bool? operationalAlertsEnabled,
    bool? syncQueueAlertsEnabled,
    bool? simulateOffline,
    int? syncIntervalSeconds,
  }) {
    return AppSettings(
      themePreference: themePreference ?? this.themePreference,
      compactDensity: compactDensity ?? this.compactDensity,
      fontScalePreset: fontScalePreset ?? this.fontScalePreset,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      screenReaderOptimized:
          screenReaderOptimized ?? this.screenReaderOptimized,
      isAutoPerformance: isAutoPerformance ?? this.isAutoPerformance,
      deviceProfile: deviceProfile ?? this.deviceProfile,
      lowPerformanceMode: lowPerformanceMode ?? this.lowPerformanceMode,
      dataSaverMode: dataSaverMode ?? this.dataSaverMode,
      preferredMedium: preferredMedium ?? this.preferredMedium,
      vibrateOnScan: vibrateOnScan ?? this.vibrateOnScan,
      soundOnScan: soundOnScan ?? this.soundOnScan,
      operationalAlertsEnabled:
          operationalAlertsEnabled ?? this.operationalAlertsEnabled,
      syncQueueAlertsEnabled:
          syncQueueAlertsEnabled ?? this.syncQueueAlertsEnabled,
      simulateOffline: simulateOffline ?? this.simulateOffline,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'themePreference': themePreference.name,
      'compactDensity': compactDensity,
      'fontScalePreset': fontScalePreset.name,
      'highContrast': highContrast,
      'reduceMotion': reduceMotion,
      'screenReaderOptimized': screenReaderOptimized,
      'isAutoPerformance': isAutoPerformance,
      'deviceProfile': deviceProfile.name,
      'lowPerformanceMode': lowPerformanceMode,
      'dataSaverMode': dataSaverMode,
      'preferredMedium': preferredMedium.name,
      'vibrateOnScan': vibrateOnScan,
      'soundOnScan': soundOnScan,
      'operationalAlertsEnabled': operationalAlertsEnabled,
      'syncQueueAlertsEnabled': syncQueueAlertsEnabled,
      'simulateOffline': simulateOffline,
      'syncIntervalSeconds': syncIntervalSeconds,
    };
  }

  factory AppSettings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const AppSettings();
    final String? themeStr = map['themePreference'] as String?;
    final String? fontStr = map['fontScalePreset'] as String?;
    final String? profileStr = map['deviceProfile'] as String?;
    final String? mediumStr = map['preferredMedium'] as String?;

    return AppSettings(
      themePreference: AppThemePreference.values.firstWhere(
        (e) => e.name == themeStr,
        orElse: () => AppThemePreference.system,
      ),
      compactDensity: map['compactDensity'] as bool? ?? false,
      fontScalePreset: FontScalePreset.values.firstWhere(
        (e) => e.name == fontStr,
        orElse: () => FontScalePreset.normal,
      ),
      highContrast: map['highContrast'] as bool? ?? false,
      reduceMotion: map['reduceMotion'] as bool? ?? false,
      screenReaderOptimized: map['screenReaderOptimized'] as bool? ?? false,
      isAutoPerformance: map['isAutoPerformance'] as bool? ?? true,
      deviceProfile: DevicePerformanceProfile.values.firstWhere(
        (e) => e.name == profileStr,
        orElse: () => DevicePerformanceProfile.lowEnd3Gb,
      ),
      lowPerformanceMode: map['lowPerformanceMode'] as bool? ?? true,
      dataSaverMode: map['dataSaverMode'] as bool? ?? false,
      preferredMedium: ReadingMedium.values.firstWhere(
        (e) => e.name == mediumStr,
        orElse: () => ReadingMedium.nfc,
      ),
      vibrateOnScan: map['vibrateOnScan'] as bool? ?? true,
      soundOnScan: map['soundOnScan'] as bool? ?? true,
      operationalAlertsEnabled: map['operationalAlertsEnabled'] as bool? ?? true,
      syncQueueAlertsEnabled: map['syncQueueAlertsEnabled'] as bool? ?? true,
      simulateOffline: map['simulateOffline'] as bool? ?? false,
      syncIntervalSeconds: map['syncIntervalSeconds'] as int? ?? 5,
    );
  }
}
