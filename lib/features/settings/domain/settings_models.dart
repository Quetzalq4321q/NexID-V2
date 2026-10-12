import '../../reading/domain/credential_models.dart';

/// Configuracion operativa y preferencias del operador en el terminal.
class AppSettings {
  const AppSettings({
    this.preferredMedium = ReadingMedium.nfc,
    this.vibrateOnScan = true,
    this.soundOnScan = true,
    this.simulateOffline = false,
    this.syncIntervalSeconds = 5,
  });

  final ReadingMedium preferredMedium;
  final bool vibrateOnScan;
  final bool soundOnScan;
  final bool simulateOffline;
  final int syncIntervalSeconds;

  AppSettings copyWith({
    ReadingMedium? preferredMedium,
    bool? vibrateOnScan,
    bool? soundOnScan,
    bool? simulateOffline,
    int? syncIntervalSeconds,
  }) {
    return AppSettings(
      preferredMedium: preferredMedium ?? this.preferredMedium,
      vibrateOnScan: vibrateOnScan ?? this.vibrateOnScan,
      soundOnScan: soundOnScan ?? this.soundOnScan,
      simulateOffline: simulateOffline ?? this.simulateOffline,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
    );
  }
}
