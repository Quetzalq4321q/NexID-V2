import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/performance/priority_task_scheduler.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/platform/hardware_bridge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/settings_models.dart';
import '../../domain/settings_search_catalog.dart';

/// Controlador reactivo de configuracion, hardware, persistencia en SharedPreferences y rendimiento.
class SettingsController extends ChangeNotifier {
  SettingsController({
    AppSettings? initialSettings,
    DeviceCapabilitiesSnapshot? initialCapabilities,
    HardwareBridge? hardwareBridge,
  })  : _hardwareBridge = hardwareBridge ?? HardwareBridge(),
        _capabilities = initialCapabilities ??
            _persistedCapabilities ??
            DeviceCapabilitiesSnapshot.fallbackWhenUnavailable(),
        _isDetectionCompleted =
            initialCapabilities != null || _persistedCapabilities != null,
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
  bool _isDetectionCompleted;
  DevicePerformanceProfile _recommendedProfile =
      DevicePerformanceProfile.lowEnd3Gb;
  AppSettings _settings;
  String _searchQuery = '';
  Timer? _searchDebounceTimer;

  AppSettings get settings => _settings;
  DeviceCapabilitiesSnapshot get capabilities => _capabilities;
  bool get isDetectionCompleted => _isDetectionCompleted;
  DevicePerformanceProfile get recommendedProfile => _recommendedProfile;
  AdaptivePerformanceLevel get recommendedAdaptiveLevel => _recommendedProfile.adaptiveLevel;
  AdaptivePerformanceLevel get activeAdaptiveLevel => _settings.deviceProfile.adaptiveLevel;
  bool get isAutoPerformance => _settings.isAutoPerformance;

  String get optimizationStatusLabel {
    if (!_isDetectionCompleted) return 'Verificando capacidades...';
    if (!_settings.isAutoPerformance) return 'Manual (${activeAdaptiveLevel.label})';
    return 'Automatica';
  }

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
      _settings.reduceMotion || _settings.lowPerformanceMode || _settings.deviceProfile.budget.forceLightweightUi;

  bool isEffectiveDark(BuildContext context) => switch (_settings.themePreference) {
        AppThemePreference.dark => true,
        AppThemePreference.light => false,
        AppThemePreference.system => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      };

  Future<void> detectAndAdaptHardware() async {
    await _loadPersistedPreferences();
    final DeviceCapabilitiesSnapshot snapshot =
        await _hardwareBridge.getDeviceCapabilities();
    applyCapabilitiesSnapshot(snapshot);
  }

  Future<void> _loadPersistedPreferences() async {
    try {
      final String? jsonStr = await _hardwareBridge.loadPreferences();
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final dynamic decoded = jsonDecode(jsonStr);
        if (decoded is Map) {
          final AppSettings loaded = AppSettings.fromMap(decoded);
          _settings = loaded;
          _persistedSettings = loaded;
          _applyPerformancePolicy();
          notifyListeners();
        }
      }
    } catch (_) {}
  }

  void applyCapabilitiesSnapshot(DeviceCapabilitiesSnapshot snapshot) {
    _capabilities = snapshot;
    _persistedCapabilities = snapshot;
    _isDetectionCompleted = true;
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
      SettingsSearchCatalog.search(_searchQuery, canAccessAdvanced: canAccessAdvanced);

  void setThemePreference(AppThemePreference p) => _update(_settings.copyWith(themePreference: p));
  void toggleCompactDensity(bool v) => _update(_settings.copyWith(compactDensity: v));
  void setFontScalePreset(FontScalePreset p) => _update(_settings.copyWith(fontScalePreset: p));
  void toggleHighContrast(bool v) => _update(_settings.copyWith(highContrast: v));
  void toggleReduceMotion(bool v) => _update(_settings.copyWith(reduceMotion: v));
  void toggleScreenReaderOptimized(bool v) => _update(_settings.copyWith(screenReaderOptimized: v));

  void setDeviceProfile(DevicePerformanceProfile profile, {bool manualOverride = true}) {
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

  void toggleLowPerformanceMode(bool v) => _update(_settings.copyWith(lowPerformanceMode: v));
  void toggleDataSaverMode(bool v) => _update(_settings.copyWith(dataSaverMode: v));

  void evictTemporaryMemoryNow() {
    DeviceMemoryGuard.instance.evictTransientMemory();
    notifyListeners();
  }

  void setPreferredMedium(ReadingMedium m) => _update(_settings.copyWith(preferredMedium: m));
  void toggleVibrateOnScan(bool v) => _update(_settings.copyWith(vibrateOnScan: v));
  void toggleSoundOnScan(bool v) => _update(_settings.copyWith(soundOnScan: v));
  void toggleOperationalAlerts(bool v) => _update(_settings.copyWith(operationalAlertsEnabled: v));
  void toggleSyncQueueAlerts(bool v) => _update(_settings.copyWith(syncQueueAlertsEnabled: v));
  void toggleSimulateOffline(bool v) => _update(_settings.copyWith(simulateOffline: v));

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
    try {
      _hardwareBridge.savePreferences(jsonEncode(next.toMap()));
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
