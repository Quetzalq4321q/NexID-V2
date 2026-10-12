import 'package:flutter/material.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/settings_models.dart';

/// Controlador local con persistencia en sesion para apariencia, accesibilidad y lectura.
class SettingsController extends ChangeNotifier {
  SettingsController({AppSettings? initialSettings})
      : _settings = initialSettings ?? _persistedSettings ?? const AppSettings();

  /// Almacenamiento local persistente durante el ciclo de vida del proceso.
  static AppSettings? _persistedSettings;

  AppSettings _settings;

  AppSettings get settings => _settings;
  AppThemePreference get themePreference => _settings.themePreference;
  ThemeMode get themeMode => _settings.themePreference.toThemeMode;
  FontScalePreset get fontScalePreset => _settings.fontScalePreset;
  double get fontScaleFactor => _settings.fontScalePreset.scaleFactor;
  bool get highContrast => _settings.highContrast;
  bool get reduceMotion => _settings.reduceMotion;
  bool get screenReaderOptimized => _settings.screenReaderOptimized;
  ReadingMedium get preferredMedium => _settings.preferredMedium;
  bool get vibrateOnScan => _settings.vibrateOnScan;
  bool get soundOnScan => _settings.soundOnScan;
  bool get simulateOffline => _settings.simulateOffline;
  int get syncIntervalSeconds => _settings.syncIntervalSeconds;

  /// Resuelve si el tema activo en pantalla es oscuro considerando el SO.
  bool isEffectiveDark(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);
    return switch (_settings.themePreference) {
      AppThemePreference.dark => true,
      AppThemePreference.light => false,
      AppThemePreference.system => platformBrightness == Brightness.dark,
    };
  }

  void setThemePreference(AppThemePreference preference) {
    if (_settings.themePreference == preference) return;
    _update(_settings.copyWith(themePreference: preference));
  }

  void setFontScalePreset(FontScalePreset preset) {
    if (_settings.fontScalePreset == preset) return;
    _update(_settings.copyWith(fontScalePreset: preset));
  }

  void toggleHighContrast(bool value) {
    if (_settings.highContrast == value) return;
    _update(_settings.copyWith(highContrast: value));
  }

  void toggleReduceMotion(bool value) {
    if (_settings.reduceMotion == value) return;
    _update(_settings.copyWith(reduceMotion: value));
  }

  void toggleScreenReaderOptimized(bool value) {
    if (_settings.screenReaderOptimized == value) return;
    _update(_settings.copyWith(screenReaderOptimized: value));
  }

  void setPreferredMedium(ReadingMedium medium) {
    if (_settings.preferredMedium == medium) return;
    _update(_settings.copyWith(preferredMedium: medium));
  }

  void toggleVibrateOnScan(bool value) {
    if (_settings.vibrateOnScan == value) return;
    _update(_settings.copyWith(vibrateOnScan: value));
  }

  void toggleSoundOnScan(bool value) {
    if (_settings.soundOnScan == value) return;
    _update(_settings.copyWith(soundOnScan: value));
  }

  void toggleSimulateOffline(bool value) {
    if (_settings.simulateOffline == value) return;
    _update(_settings.copyWith(simulateOffline: value));
  }

  void resetToDefaults() {
    _update(const AppSettings());
  }

  void _update(AppSettings next) {
    _settings = next;
    _persistedSettings = next;
    notifyListeners();
  }
}
