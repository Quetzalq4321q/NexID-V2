import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/performance/device_performance_tier.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/settings_controller.dart';

/// Seccion 3: Rendimiento automatico e inteligente sin seleccion manual de RAM
/// para el usuario estandar, mas Seccion 4: Almacenamiento y cache segura.
class LowEndPerformanceCard extends StatelessWidget {
  const LowEndPerformanceCard({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final AdaptivePerformanceLevel level = controller.activeAdaptiveLevel;
    final bool isAuto = controller.isAutoPerformance;

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
                    'Adaptacion Inteligente de Rendimiento',
                    style: AppTypography.titleMedium.copyWith(
                      fontSize: 16,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
                StatusBadge(
                  label: isAuto ? 'Automatico activo' : 'Modo manual',
                  type: isAuto ? BadgeType.confirmed : BadgeType.pending,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
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
                    'Perfil activo: ${level.label}',
                    style: AppTypography.bodySmall.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    level.description,
                    style: AppTypography.caption.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
                  if (!isAuto) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.auto_mode_outlined, size: 16),
                        label: const Text('Restaurar perfil automatico'),
                        onPressed: controller.restoreAutomaticPerformance,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXSmall),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Modo de ahorro de recursos visuales',
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
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Ahorro de datos y carga diferida en red movil',
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Reduce precargas secundarias cuando la red es inestable',
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              value: controller.dataSaverMode,
              onChanged: controller.toggleDataSaverMode,
            ),
          ],
        ),
      ),
    );
  }
}

/// Seccion 4: Almacenamiento y cache temporal separada de la cola SQLite.
class StorageAndCacheCard extends StatelessWidget {
  const StorageAndCacheCard({
    super.key,
    required this.controller,
    required this.pendingSyncCount,
  });

  final SettingsController controller;
  final int pendingSyncCount;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final PerformanceBudget budget = controller.performanceBudget;
    final DeviceCapabilitiesSnapshot caps = controller.capabilities;
    final int maxMb = (budget.maxImageCacheBytes / (1024 * 1024)).round();

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
            Text(
              'Presupuesto de Cache y Almacenamiento Local',
              style: AppTypography.titleMedium.copyWith(
                fontSize: 16,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Cache img: max ${budget.maxImageCacheCount} ($maxMb MB) · Fichas RAM: ${budget.maxHydratedStudentDetails} · Lote: ${budget.listPageSize}',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Almacenamiento interno libre: ${caps.storageAvailableLabel} · Cola SQLite protegida: $pendingSyncCount pendientes',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSmall),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
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
            ),
          ],
        ),
      ),
    );
  }
}
