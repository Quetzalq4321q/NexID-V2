import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_version.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../../reading/domain/credential_models.dart';
import '../../../session/domain/session_models.dart';
import '../../../session/presentation/controllers/session_controller.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/accessibility_controls_card.dart';
import '../widgets/low_end_performance_card.dart';
import '../widgets/operator_profile_card.dart';
import '../widgets/theme_appearance_card.dart';

/// Pantalla 5: Configuracion, apariencia, accesibilidad WCAG 2.2 y Prioridad 0.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.settingsController,
    required this.sessionController,
    required this.placesController,
    required this.syncController,
  });

  final SettingsController settingsController;
  final SessionController sessionController;
  final PlacesController placesController;
  final SyncController syncController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        settingsController,
        sessionController,
        placesController,
        syncController,
      ]),
      builder: (BuildContext context, _) {
        final NexIdPalette palette = NexIdPalette.of(context);
        final OperatorUser? user = sessionController.currentUser;
        final String placeName =
            placesController.selectedPlace?.name ?? 'Punto no asignado';

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSectionHeader('Apariencia y Accesibilidad (WCAG 2.2)', palette),
                    ThemeAppearanceCard(controller: settingsController),
                    const SizedBox(height: AppDimensions.spaceMedium),
                    AccessibilityControlsCard(controller: settingsController),
                    const SizedBox(height: AppDimensions.spaceMedium),
                    LowEndPerformanceCard(controller: settingsController),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    if (user != null) ...[
                      _buildSectionHeader('Cuenta Operativa Activa', palette),
                      OperatorProfileCard(
                        user: user,
                        placeName: placeName,
                        onLogout: () => sessionController.logout(),
                      ),
                      const SizedBox(height: AppDimensions.spaceLarge),
                    ],
                    _buildSectionHeader('Preferencias de Lectura', palette),
                    _buildReadingSection(context, palette),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildSectionHeader('Sincronizacion y Red', palette),
                    _buildSyncSection(context, palette),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildSectionHeader('Informacion del Sistema', palette),
                    _buildSystemSection(palette),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildActionButtons(palette),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(color: palette.textSecondary, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildReadingSection(BuildContext context, NexIdPalette palette) {
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Medio preferido de lectura'),
            subtitle: Text(
              settingsController.preferredMedium == ReadingMedium.nfc
                  ? 'NFC por proximidad'
                  : 'QR por camara optica',
            ),
            trailing: DropdownButton<ReadingMedium>(
              value: settingsController.preferredMedium,
              dropdownColor: palette.surfaceElevated,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: ReadingMedium.nfc, child: Text('NFC')),
                DropdownMenuItem(value: ReadingMedium.qr, child: Text('QR')),
              ],
              onChanged: (ReadingMedium? val) {
                if (val != null) settingsController.setPreferredMedium(val);
              },
            ),
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            title: const Text('Vibracion al detectar credencial'),
            value: settingsController.vibrateOnScan,
            onChanged: settingsController.toggleVibrateOnScan,
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            title: const Text('Confirmacion sonora al registrar'),
            value: settingsController.soundOnScan,
            onChanged: settingsController.toggleSoundOnScan,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection(BuildContext context, NexIdPalette palette) {
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Simular modo sin red (Offline)'),
            subtitle: const Text('Obliga a encolar eventos en SQLite local'),
            value: settingsController.simulateOffline,
            onChanged: settingsController.toggleSimulateOffline,
          ),
          Divider(height: 1, color: palette.border),
          ListTile(
            title: const Text('Intervalo de sincronizacion'),
            subtitle: Text('${settingsController.syncIntervalSeconds} segundos (automatico)'),
            trailing: const StatusBadge(label: '5s cola', type: BadgeType.info),
          ),
          Divider(height: 1, color: palette.border),
          ListTile(
            title: const Text('Forzar sincronizacion ahora'),
            subtitle: const Text('Envia los eventos pendientes a MariaDB'),
            trailing: OutlinedButton(
              onPressed: () => syncController.syncNow(),
              child: const Text('Sincronizar'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSection(NexIdPalette palette) {
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
              style: AppTypography.bodySmall.copyWith(color: palette.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Persistencia: SQLite Outbox local (2 pasadas / 5s)',
              style: AppTypography.caption.copyWith(color: palette.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              'Servidor remoto: PHP / MariaDB (nexlabs.net.pe)',
              style: AppTypography.caption.copyWith(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(NexIdPalette palette) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.restore_outlined, size: 18),
            label: const Text('Restaurar ajustes'),
            onPressed: () => settingsController.resetToDefaults(),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSmall),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout_outlined, size: 18),
            label: const Text('Cerrar Sesion'),
            style: OutlinedButton.styleFrom(
              foregroundColor: palette.error,
              side: BorderSide(color: palette.error),
            ),
            onPressed: () => sessionController.logout(),
          ),
        ),
      ],
    );
  }
}
