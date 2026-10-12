import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_version.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../../session/domain/session_models.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../controllers/settings_controller.dart';
import 'operator_profile_card.dart';

/// Seccion 5: Conectividad y sincronizacion automatica cada 5 segundos.
class ConnectivitySyncSettingsCard extends StatelessWidget {
  const ConnectivitySyncSettingsCard({
    super.key,
    required this.settingsController,
    required this.syncController,
  });

  final SettingsController settingsController;
  final SyncController syncController;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final DeviceCapabilitiesSnapshot caps = settingsController.capabilities;
    final String netLabel = settingsController.simulateOffline
        ? 'Modo sin red simulado (Cola local activa)'
        : (caps.hasActiveNetwork ? 'Conectado (${caps.connectionType})' : 'Sin conexion detectada');

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Estado de conectividad y cola local'),
            subtitle: Text('$netLabel · Pendientes en SQLite: ${syncController.stats.pendingCount}'),
            trailing: const StatusBadge(label: '5s cola', type: BadgeType.info),
          ),
          Divider(height: 1, color: palette.border),
          ListTile(
            title: const Text('Forzar sincronizacion ahora'),
            subtitle: const Text('Envia eventos pendientes hacia MariaDB'),
            trailing: OutlinedButton(
              onPressed: () => syncController.syncNow(),
              child: const Text('Sincronizar'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Seccion 6: NFC, QR, respuesta haptica/sonora y guia de lectura en 2 pasadas.
class NfcAndRecordsSettingsCard extends StatelessWidget {
  const NfcAndRecordsSettingsCard({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final DeviceCapabilitiesSnapshot caps = controller.capabilities;
    final bool nfcReady = caps.hasNfcHardware && caps.isNfcEnabled;
    final String nfcStatusText = !caps.hasNfcHardware
        ? 'Sin hardware NFC en este equipo — Lectura QR disponible'
        : (caps.isNfcEnabled ? 'Lector NFC disponible y activo' : 'Lector NFC desactivado en Android');

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Compatibilidad de hardware NFC'),
            subtitle: Text(nfcStatusText),
            trailing: StatusBadge(
              label: nfcReady ? 'NFC Listo' : 'Usar QR',
              type: nfcReady ? BadgeType.confirmed : BadgeType.pending,
            ),
          ),
          Divider(height: 1, color: palette.border),
          ListTile(
            title: const Text('Medio preferido de lectura'),
            subtitle: Text(
              controller.preferredMedium == ReadingMedium.nfc ? 'NFC por proximidad' : 'QR por camara optica',
            ),
            trailing: DropdownButton<ReadingMedium>(
              value: controller.preferredMedium,
              dropdownColor: palette.surfaceElevated,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: ReadingMedium.nfc, child: Text('NFC')),
                DropdownMenuItem(value: ReadingMedium.qr, child: Text('QR')),
              ],
              onChanged: (ReadingMedium? v) => v != null ? controller.setPreferredMedium(v) : null,
            ),
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            title: const Text('Vibracion al detectar credencial'),
            value: controller.vibrateOnScan,
            onChanged: controller.toggleVibrateOnScan,
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            title: const Text('Confirmacion sonora al registrar'),
            value: controller.soundOnScan,
            onChanged: controller.toggleSoundOnScan,
          ),
          Divider(height: 1, color: palette.border),
          const ListTile(
            dense: true,
            leading: Icon(Icons.info_outline, size: 18),
            title: Text('Guia de lectura: Validacion en 2 pasadas'),
            subtitle: Text('1ra pasada consulta vigencia; 2da pasada en 10s confirma ingreso/salida.'),
          ),
        ],
      ),
    );
  }
}

/// Seccion 7: Notificaciones y alertas operativas.
class NotificationsSettingsCard extends StatelessWidget {
  const NotificationsSettingsCard({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Alertas operativas de lectura'),
            subtitle: const Text('Muestra avisos ante credenciales vencidas o bloqueadas'),
            value: controller.operationalAlertsEnabled,
            onChanged: controller.toggleOperationalAlerts,
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            title: const Text('Avisos de cola pendiente de sincronizacion'),
            subtitle: const Text('Notifica eventos locales en espera de red'),
            value: controller.syncQueueAlertsEnabled,
            onChanged: controller.toggleSyncQueueAlerts,
          ),
        ],
      ),
    );
  }
}

/// Seccion 8: Privacidad, seguridad, cuenta activa y politicas protegidas.
class PrivacySecuritySettingsCard extends StatelessWidget {
  const PrivacySecuritySettingsCard({
    super.key,
    required this.user,
    required this.placeName,
    required this.onLogout,
  });

  final OperatorUser? user;
  final String placeName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (user != null) ...[
          OperatorProfileCard(user: user!, placeName: placeName, onLogout: onLogout),
          const SizedBox(height: AppDimensions.spaceSmall),
        ],
        Material(
          color: palette.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            side: BorderSide(color: palette.border),
          ),
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.lock_outline, size: 18),
            title: Text('Politicas de seguridad protegidas (Inmutables)'),
            subtitle: Text('La validacion NFC, SQLite local y la autoridad del servidor son protegidas.'),
          ),
        ),
      ],
    );
  }
}

/// Seccion 9: Informacion de la aplicacion y resumen de hardware compatible.
class AppHardwareInfoCard extends StatelessWidget {
  const AppHardwareInfoCard({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final DeviceCapabilitiesSnapshot caps = controller.capabilities;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NexID Mobile ${AppVersion.label}',
              style: AppTypography.bodySmall.copyWith(color: palette.textPrimary, fontWeight: FontWeight.w700),
            ),
            Text(
              'Hardware detectado: RAM ${caps.totalRamLabel} (${caps.availableRamLabel}) · CPU ${caps.processorSummaryLabel}',
              style: AppTypography.caption.copyWith(color: palette.textSecondary),
            ),
            Text(
              'Sistema: ${caps.androidVersionLabel} · Persistencia: SQLite Outbox local (2 pasadas / 5s)',
              style: AppTypography.caption.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
