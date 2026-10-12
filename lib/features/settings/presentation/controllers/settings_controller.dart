import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/performance/priority_task_scheduler.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/platform/hardware_bridge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/settings_models.dart';
import '../../domain/settings_search_catalog.dart';

/// Controlador reactivo de configuracion, deteccion real de hardware Android,
/// adaptacion automatica de rendimiento (Prioridad 0) y buscador de ajustes.
class SettingsController extends ChangeNotifier {
  SettingsController({
    AppSettings? initialSettings,
    DeviceCapabilitiesSnapshot? initialCapabilities,
    HardwareBridge? hardwareBridge,
  })  : _hardwareBridge = hardwareBridge ?? HardwareBridge(),
        _capabilities = initialCapabilities ??
            _persistedCapabilities ??
            DeviceCapabilitiesSnapshot.fallbackWhenUnavailable(),
        _settings =
            initialSettings ?? _persistedSettings ?? const AppSettings() {
    _recommendedProfile = DevicePerformanceProfile.resolveAutomaticProfile(
      _capabilities,
      memoryPressureEvents: DeviceMemoryGuard.instance.memoryCleanupCount,
    );
    if (initialCapabilities != null && _settings.isAutoPerformance) {
      _settings = _settings.copyWith(
        deviceProfile: _recommendedProfile,
        lowPerformanceMode: _recommendedProfile.budget.forceLightweightUi,
      );
    }
    _applyPerformancePolicy();
  }

  static AppSettings? _persistedSettings;
  static DeviceCapabilitiesSnapshot? _persistedCapabilities;

  final HardwareBridge _hardwareBridge;
  DeviceCapabilitiesSnapshot _capabilities;
  DevicePerformanceProfile _recommendedProfile =
      DevicePerformanceProfile.lowEnd3Gb;
  AppSettings _settings;
  String _searchQuery = '';
  Timer? _searchDebounceTimer;

  AppSettings get settings => _settings;
  DeviceCapabilitiesSnapshot get capabilities => _capabilities;
  DevicePerformanceProfile get recommendedProfile => _recommendedProfile;
  AdaptivePerformanceLevel get recommendedAdaptiveLevel =>
      _recommendedProfile.adaptiveLevel;
  AdaptivePerformanceLevel get activeAdaptiveLevel =>
      _settings.deviceProfile.adaptiveLevel;
  bool get isAutoPerformance => _settings.isAutoPerformance;
  AppThemePreference get themePreference => _settings.themePreference;
  ThemeMode get themeMode => _settings.themePreference.toThemeMode;
  bool get compactDensity => _settings.compactDensity;
  FontScalePreset get fontScalePreset => _settings.fontScalePreset;
  double get fontScaleFactor => _settings.fontScalePreset.scaleFactor;
  bool get highContrast => _settings.highContrast;
  bool get reduceMotion => _settings.reduceMotion;
  bool get screenReaderOptimized => _settings.screenReaderOptimized;
  DevicePerformanceProfile get deviceProfile => _settings.deviceProfile;
  PerformanceBudget get performanceBudget => _settings.deviceProfile.budget;
  bool get lowPerformanceMode => _settings.lowPerformanceMode;
  bool get dataSaverMode => _settings.dataSaverMode;
  ReadingMedium get preferredMedium => _settings.preferredMedium;
  bool get vibrateOnScan => _settings.vibrateOnScan;
  bool get soundOnScan => _settings.soundOnScan;
  bool get operationalAlertsEnabled => _settings.operationalAlertsEnabled;
  bool get syncQueueAlertsEnabled => _settings.syncQueueAlertsEnabled;
  bool get simulateOffline => _settings.simulateOffline;
  int get syncIntervalSeconds => _settings.syncIntervalSeconds;
  String get searchQuery => _searchQuery;

  bool get effectiveReduceMotion =>
      _settings.reduceMotion ||
      _settings.lowPerformanceMode ||
      _settings.deviceProfile.budget.forceLightweightUi;

  bool isEffectiveDark(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);
    return switch (_settings.themePreference) {
      AppThemePreference.dark => true,
      AppThemePreference.light => false,
      AppThemePreference.system => platformBrightness == Brightness.dark,
    };
  }

  Future<void> detectAndAdaptHardware() async {
    final DeviceCapabilitiesSnapshot snapshot =
        await _hardwareBridge.getDeviceCapabilities();
    applyCapabilitiesSnapshot(snapshot);
  }

  void applyCapabilitiesSnapshot(DeviceCapabilitiesSnapshot snapshot) {
    _capabilities = snapshot;
    _persistedCapabilities = snapshot;
    _recommendedProfile = DevicePerformanceProfile.resolveAutomaticProfile(
      snapshot,
      memoryPressureEvents: DeviceMemoryGuard.instance.memoryCleanupCount,
    );
    if (_settings.isAutoPerformance) {
      _update(_settings.copyWith(
        deviceProfile: _recommendedProfile,
        lowPerformanceMode: _recommendedProfile.budget.forceLightweightUi,
      ));
    } else {
      notifyListeners();
    }
  }

  void onRuntimeMemoryPressure() {
    _recommendedProfile = DevicePerformanceProfile.resolveAutomaticProfile(
      _capabilities,
      memoryPressureEvents: DeviceMemoryGuard.instance.memoryCleanupCount,
    );
    if (_settings.isAutoPerformance &&
        _settings.deviceProfile != _recommendedProfile) {
      _update(_settings.copyWith(
        deviceProfile: _recommendedProfile,
        lowPerformanceMode: _recommendedProfile.budget.forceLightweightUi,
      ));
    } else {
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchDebounceTimer?.cancel();
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSearchQueryDebounced(String query) {
    _searchDebounceTimer?.cancel();
    final int delayMs = performanceBudget.searchDebounceMs;
    _searchDebounceTimer = Timer(Duration(milliseconds: delayMs), () {
      setSearchQuery(query);
    });
  }

  List<SettingSearchEntry> searchSettings({required bool canAccessAdvanced}) =>
      SettingsSearchCatalog.search(
        _searchQuery,
        canAccessAdvanced: canAccessAdvanced,
      );

  void setThemePreference(AppThemePreference preference) =>
      _update(_settings.copyWith(themePreference: preference));

  void toggleCompactDensity(bool value) =>
      _update(_settings.copyWith(compactDensity: value));

  void setFontScalePreset(FontScalePreset preset) =>
      _update(_settings.copyWith(fontScalePreset: preset));

  void toggleHighContrast(bool value) =>
      _update(_settings.copyWith(highContrast: value));

  void toggleReduceMotion(bool value) =>
      _update(_settings.copyWith(reduceMotion: value));

  void toggleScreenReaderOptimized(bool value) =>
      _update(_settings.copyWith(screenReaderOptimized: value));

  void setDeviceProfile(
    DevicePerformanceProfile profile, {
    bool manualOverride = true,
  }) {
    _update(_settings.copyWith(
      isAutoPerformance: !manualOverride,
      deviceProfile: profile,
      lowPerformanceMode: profile.budget.forceLightweightUi,
    ));
  }

  void setManualAdaptiveLevel(AdaptivePerformanceLevel level) =>
      setDeviceProfile(level.defaultProfile, manualOverride: true);

  void restoreAutomaticPerformance() {
    _update(_settings.copyWith(
      isAutoPerformance: true,
      deviceProfile: _recommendedProfile,
      lowPerformanceMode: _recommendedProfile.budget.forceLightweightUi,
    ));
  }

  void toggleLowPerformanceMode(bool value) =>
      _update(_settings.copyWith(lowPerformanceMode: value));

  void toggleDataSaverMode(bool value) =>
      _update(_settings.copyWith(dataSaverMode: value));

  void evictTemporaryMemoryNow() {
    DeviceMemoryGuard.instance.evictTransientMemory();
    notifyListeners();
  }

  void setPreferredMedium(ReadingMedium medium) =>
      _update(_settings.copyWith(preferredMedium: medium));

  void toggleVibrateOnScan(bool value) =>
      _update(_settings.copyWith(vibrateOnScan: value));

  void toggleSoundOnScan(bool value) =>
      _update(_settings.copyWith(soundOnScan: value));

  void toggleOperationalAlerts(bool value) =>
      _update(_settings.copyWith(operationalAlertsEnabled: value));

  void toggleSyncQueueAlerts(bool value) =>
      _update(_settings.copyWith(syncQueueAlertsEnabled: value));

  void toggleSimulateOffline(bool value) =>
      _update(_settings.copyWith(simulateOffline: value));

  void resetToDefaults() {
    _update(AppSettings(
      isAutoPerformance: true,
      deviceProfile: _recommendedProfile,
      lowPerformanceMode: _recommendedProfile.budget.forceLightweightUi,
    ));
  }

  void _applyPerformancePolicy() {
    DeviceMemoryGuard.instance.applyProfile(_settings.deviceProfile);
    PriorityTaskScheduler.instance.configureMaxConcurrency(
      _settings.deviceProfile.budget.maxConcurrentBackgroundTasks,
    );
  }

  void _update(AppSettings next) {
    _settings = next;
    _persistedSettings = next;
    _applyPerformancePolicy();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
