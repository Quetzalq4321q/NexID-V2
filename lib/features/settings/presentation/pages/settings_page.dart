import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_version.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../../reading/domain/credential_models.dart';
import '../../../session/domain/session_models.dart';
import '../../../session/presentation/controllers/session_controller.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../controllers/settings_controller.dart';
import '../widgets/operator_profile_card.dart';

/// Pantalla 5: Configuracion y preferencias del terminal del operador.
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
        final OperatorUser? user = sessionController.currentUser;
        final String placeName =
            placesController.selectedPlace?.name ?? 'Punto no asignado';

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (user != null) ...[
                      OperatorProfileCard(
                        user: user,
                        placeName: placeName,
                        onLogout: () => sessionController.logout(),
                      ),
                      const SizedBox(height: AppDimensions.spaceLarge),
                    ],
                    _buildSectionHeader('Preferencias de Lectura'),
                    _buildReadingSection(context),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildSectionHeader('Sincronizacion y Red'),
                    _buildSyncSection(context),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildSectionHeader('Informacion del Sistema'),
                    _buildSystemSection(),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildReadingSection(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text('Medio preferido de lectura'),
            subtitle: Text(settingsController.preferredMedium == ReadingMedium.nfc
                ? 'NFC por proximidad'
                : 'QR por camara optica'),
            trailing: DropdownButton<ReadingMedium>(
              value: settingsController.preferredMedium,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(
                  value: ReadingMedium.nfc,
                  child: Text('NFC'),
                ),
                DropdownMenuItem(
                  value: ReadingMedium.qr,
                  child: Text('QR'),
                ),
              ],
              onChanged: (ReadingMedium? val) {
                if (val != null) settingsController.setPreferredMedium(val);
              },
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          SwitchListTile(
            title: const Text('Vibracion al detectar credencial'),
            value: settingsController.vibrateOnScan,
            onChanged: (bool val) => settingsController.toggleVibrateOnScan(val),
          ),
          const Divider(height: 1, color: AppColors.border),
          SwitchListTile(
            title: const Text('Confirmacion sonora al registrar'),
            value: settingsController.soundOnScan,
            onChanged: (bool val) => settingsController.toggleSoundOnScan(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Simular modo sin red (Offline)'),
            subtitle: const Text('Obliga a encolar eventos en SQLite local'),
            value: settingsController.simulateOffline,
            onChanged: (bool val) {
              settingsController.toggleSimulateOffline(val);
            },
          ),
          const Divider(height: 1, color: AppColors.border),
          ListTile(
            title: const Text('Intervalo de sincronizacion'),
            subtitle: Text('${settingsController.syncIntervalSeconds} segundos (automatico)'),
            trailing: const StatusBadge(label: '5s cola', type: BadgeType.info),
          ),
          const Divider(height: 1, color: AppColors.border),
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

  Widget _buildSystemSection() {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: const BorderSide(color: AppColors.border),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NexID Mobile ${AppVersion.label}', style: AppTypography.bodySmall),
            SizedBox(height: 4),
            Text('Persistencia: SQLite Outbox local (2 pasadas / 5s)', style: AppTypography.caption),
            SizedBox(height: 2),
            Text('Servidor remoto: PHP / MariaDB (nexlabs.net.pe)', style: AppTypography.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout_outlined, size: 18),
        label: const Text('Cerrar Sesion'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
        ),
        onPressed: () => sessionController.logout(),
      ),
    );
  }
}
