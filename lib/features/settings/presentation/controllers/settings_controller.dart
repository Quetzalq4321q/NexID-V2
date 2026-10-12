import 'package:flutter/foundation.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/settings_models.dart';

/// Controlador local para la gestion de preferencias y ajustes del operador.
class SettingsController extends ChangeNotifier {
  SettingsController({AppSettings? initialSettings})
      : _settings = initialSettings ?? const AppSettings();

  AppSettings _settings;

  AppSettings get settings => _settings;
  ReadingMedium get preferredMedium => _settings.preferredMedium;
  bool get vibrateOnScan => _settings.vibrateOnScan;
  bool get soundOnScan => _settings.soundOnScan;
  bool get simulateOffline => _settings.simulateOffline;
  int get syncIntervalSeconds => _settings.syncIntervalSeconds;

  void setPreferredMedium(ReadingMedium medium) {
    if (_settings.preferredMedium == medium) return;
    _settings = _settings.copyWith(preferredMedium: medium);
    notifyListeners();
  }

  void toggleVibrateOnScan(bool value) {
    if (_settings.vibrateOnScan == value) return;
    _settings = _settings.copyWith(vibrateOnScan: value);
    notifyListeners();
  }

  void toggleSoundOnScan(bool value) {
    if (_settings.soundOnScan == value) return;
    _settings = _settings.copyWith(soundOnScan: value);
    notifyListeners();
  }

  void toggleSimulateOffline(bool value) {
    if (_settings.simulateOffline == value) return;
    _settings = _settings.copyWith(simulateOffline: value);
    notifyListeners();
  }

  void resetToDefaults() {
    _settings = const AppSettings();
    notifyListeners();
  }
}
