import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/settings_controller.dart';

/// Tarjeta de configuracion y simulacion de dispositivos Android de gama baja
/// conforme a PRIORIDAD 0 (2 GB, 3 GB, 4 GB de RAM y condiciones adversas).
class LowEndPerformanceCard extends StatelessWidget {
  const LowEndPerformanceCard({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final PerformanceBudget budget = controller.performanceBudget;
    final int maxMb = (budget.maxImageCacheBytes / (1024 * 1024)).round();

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Optimización Gama Baja (Prioridad 0)',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                StatusBadge(
                  label: '${budget.simulatedTotalRamMb ~/ 1024} GB RAM',
                  type: BadgeType.info,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              controller.deviceProfile.description,
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceMedium),
            DropdownButtonFormField<DevicePerformanceProfile>(
              initialValue: controller.deviceProfile,
              isExpanded: true,
              dropdownColor: palette.surfaceElevated,
              decoration: const InputDecoration(
                labelText: 'Perfil de hardware objetivo / simulado',
              ),
              items: DevicePerformanceProfile.values
                  .map((DevicePerformanceProfile p) {
                return DropdownMenuItem<DevicePerformanceProfile>(
                  value: p,
                  child: Text(
                    p.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: palette.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (DevicePerformanceProfile? val) {
                if (val != null) controller.setDeviceProfile(val);
              },
            ),
            const SizedBox(height: AppDimensions.spaceSmall),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Modo de rendimiento reducido',
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Skeletons estaticos, sin efectos pesados y prioridad NFC',
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              value: controller.lowPerformanceMode,
              onChanged: controller.toggleLowPerformanceMode,
            ),
            Divider(height: 1, color: palette.border),
            const SizedBox(height: AppDimensions.spaceSmall),
            Wrap(
              spacing: 8.0,
              runSpacing: 6.0,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Cache img: max ${budget.maxImageCacheCount} ($maxMb MB) · Fichas RAM: ${budget.maxHydratedStudentDetails} · Lote: ${budget.listPageSize}',
                  style: AppTypography.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.cleaning_services_outlined, size: 16),
                  label: const Text('Liberar cache temporal'),
                  onPressed: () {
                    controller.evictTemporaryMemoryNow();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Memoria temporal e imagenes liberadas. Cola SQLite intacta.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
