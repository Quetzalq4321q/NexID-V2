import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../session/presentation/controllers/session_controller.dart';
import '../controllers/settings_controller.dart';

/// Seccion 10: Configuracion avanzada restringida por permisos reales de
/// Administrador (`sessionController.canAccessAdvancedSettings`).
class AdvancedSettingsCard extends StatelessWidget {
  const AdvancedSettingsCard({
    super.key,
    required this.settingsController,
    required this.sessionController,
  });

  final SettingsController settingsController;
  final SessionController sessionController;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    if (!sessionController.canAccessAdvancedSettings) {
      return _buildRestrictedAccessCard(context, palette);
    }
    return _buildAuthorizedPanel(context, palette);
  }

  Widget _buildRestrictedAccessCard(BuildContext context, NexIdPalette palette) {
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: ListTile(
        leading: Icon(Icons.admin_panel_settings_outlined, color: palette.primary),
        title: const Text('Configuracion avanzada restringida'),
        subtitle: const Text(
          'Requiere sesion con rol Administrador para modificar perfiles manuales o diagnostico.',
        ),
        trailing: OutlinedButton(
          key: const Key('authorize_advanced_settings_button'),
          onPressed: () => _showAdminAuthorizationDialog(context),
          child: const Text('Autorizar'),
        ),
      ),
    );
  }

  Widget _buildAuthorizedPanel(BuildContext context, NexIdPalette palette) {
    final DeviceCapabilitiesSnapshot caps = settingsController.capabilities;
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Panel Avanzado de Diagnostico y Simulacion',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                const StatusBadge(label: 'Administrador', type: BadgeType.info),
              ],
            ),
            const SizedBox(height: 6),
            _buildRealHardwareTelemetryBox(caps, palette),
            const SizedBox(height: AppDimensions.spaceMedium),
            _buildAdaptiveDropdown(palette),
            const SizedBox(height: AppDimensions.spaceSmall),
            _buildProfileDropdown(palette),
            const SizedBox(height: AppDimensions.spaceXSmall),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Simular modo sin red (Offline)'),
              subtitle: const Text('Obliga a encolar eventos en SQLite local'),
              value: settingsController.simulateOffline,
              onChanged: settingsController.toggleSimulateOffline,
            ),
            Divider(height: 1, color: palette.border),
            const SizedBox(height: AppDimensions.spaceSmall),
            Wrap(
              spacing: 8.0,
              runSpacing: 6.0,
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  key: const Key('restore_auto_performance_button'),
                  icon: const Icon(Icons.auto_fix_high_outlined, size: 16),
                  label: const Text('Volver al modo automatico recomendado'),
                  onPressed: settingsController.restoreAutomaticPerformance,
                ),
                if (sessionController.currentUser?.canAccessAdvancedSettings != true)
                  TextButton(
                    onPressed: sessionController.revokeDiagnosticSession,
                    child: const Text('Cerrar modo diagnostico'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdaptiveDropdown(NexIdPalette palette) {
    return DropdownButtonFormField<AdaptivePerformanceLevel>(
      key: const Key('advanced_adaptive_level_dropdown'),
      initialValue: settingsController.activeAdaptiveLevel,
      isExpanded: true,
      dropdownColor: palette.surfaceElevated,
      decoration: const InputDecoration(labelText: 'Nivel interno de rendimiento'),
      items: AdaptivePerformanceLevel.values
          .map((AdaptivePerformanceLevel l) => DropdownMenuItem(
                value: l,
                child: Text(l.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ))
          .toList(),
      onChanged: (AdaptivePerformanceLevel? val) {
        if (val != null) settingsController.setManualAdaptiveLevel(val);
      },
    );
  }

  Widget _buildProfileDropdown(NexIdPalette palette) {
    return DropdownButtonFormField<DevicePerformanceProfile>(
      key: const Key('advanced_device_profile_dropdown'),
      initialValue: settingsController.deviceProfile,
      isExpanded: true,
      dropdownColor: palette.surfaceElevated,
      decoration: const InputDecoration(labelText: 'Perfil de hardware objetivo / simulado'),
      items: DevicePerformanceProfile.values
          .map((DevicePerformanceProfile p) => DropdownMenuItem(
                value: p,
                child: Text(
                  p.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySmall.copyWith(color: palette.textPrimary),
                ),
              ))
          .toList(),
      onChanged: (DevicePerformanceProfile? val) {
        if (val != null) settingsController.setDeviceProfile(val);
      },
    );
  }

  Widget _buildRealHardwareTelemetryBox(
    DeviceCapabilitiesSnapshot caps,
    NexIdPalette palette,
  ) {
    final String lowRamFlag = caps.isLowRamDevice ? 'Si (LowRam)' : 'No';
    final String powerFlag = caps.isPowerSaveMode ? 'Activo' : 'Normal';
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceSmall),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Telemetria real de Android (Inalterada por simulacion):',
            style: AppTypography.caption.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'RAM total: ${caps.totalRamLabel} · Libre: ${caps.availableRamLabel} · LowRam OS: $lowRamFlag',
            style: AppTypography.caption.copyWith(color: palette.textSecondary),
          ),
          Text(
            'CPU: ${caps.processorSummaryLabel} (${caps.hardwareBoard}) · Energia: $powerFlag · Termico: ${caps.thermalStatus}',
            style: AppTypography.caption.copyWith(color: palette.textSecondary),
          ),
          Text(
            'Recomendacion automatica: ${settingsController.recommendedProfile.label}',
            style: AppTypography.caption.copyWith(color: palette.primary),
          ),
        ],
      ),
    );
  }

  Future<void> _showAdminAuthorizationDialog(BuildContext context) async {
    final TextEditingController textCtrl = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Autorizacion de Administrador'),
        content: TextField(
          key: const Key('admin_username_input'),
          controller: textCtrl,
          decoration: const InputDecoration(
            labelText: 'Usuario administrador institucional',
            hintText: 'admin.general',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('confirm_admin_auth_button'),
            onPressed: () {
              final bool ok = sessionController.authorizeDiagnosticSession(textCtrl.text);
              Navigator.of(dialogContext).pop();
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cuenta sin privilegios de Administrador.')),
                );
              }
            },
            child: const Text('Verificar'),
          ),
        ],
      ),
    );
    textCtrl.dispose();
  }
}
