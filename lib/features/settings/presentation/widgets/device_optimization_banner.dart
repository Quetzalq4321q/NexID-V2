import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/platform/device_capabilities_models.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/settings_search_catalog.dart';
import '../controllers/settings_controller.dart';

/// Encabezado compacto y proporcionado del apartado Configuracion:
/// Flecha de regreso a la izquierda, titulo y el icono de ajustes alineado.
class SettingsHeaderBar extends StatelessWidget {
  const SettingsHeaderBar({
    super.key,
    required this.title,
    required this.onBack,
    required this.onSettingsIconTap,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onSettingsIconTap;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
      child: Row(
        children: [
          IconButton(
            key: const Key('settings_back_button'),
            icon: Icon(Icons.arrow_back, color: palette.textPrimary, size: 22),
            tooltip: 'Regresar a la pantalla anterior',
            visualDensity: VisualDensity.compact,
            onPressed: onBack,
          ),
          const SizedBox(width: AppDimensions.spaceXSmall),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            key: const Key('settings_header_icon'),
            icon: Icon(Icons.settings_outlined, color: palette.primary, size: 22),
            tooltip: 'Configuracion y diagnostico autorizado',
            visualDensity: VisualDensity.compact,
            onPressed: onSettingsIconTap,
          ),
        ],
      ),
    );
  }
}

/// Tarjeta destacada de Optimizacion del dispositivo debajo del buscador.
/// Obtiene su estado del sistema real de deteccion de capacidades sin inventar
/// confirmacion operativa si la deteccion aun no ha finalizado.
class DeviceOptimizationBannerCard extends StatelessWidget {
  const DeviceOptimizationBannerCard({
    super.key,
    required this.controller,
    this.onTap,
  });

  final SettingsController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final DeviceCapabilitiesSnapshot caps = controller.capabilities;
    final bool isReadyAuto =
        controller.isDetectionCompleted && controller.isAutoPerformance;
    final String statusText = 'Estado: ${controller.optimizationStatusLabel}';
    final String hardwareNote = caps.isRealAndroidTelemetry
        ? 'RAM ${caps.totalRamLabel}'
        : 'Perfil adaptativo seguro';

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: InkWell(
        key: const Key('device_optimization_banner_card'),
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopRow(statusText, isReadyAuto, palette),
              const SizedBox(height: AppDimensions.spaceSmall),
              Text(
                'El sistema adapta el consumo de recursos segun las capacidades y condiciones del dispositivo',
                style: AppTypography.caption.copyWith(color: palette.textSecondary),
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              _buildBottomManagementBar(hardwareNote, palette),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(
    String statusText,
    bool isReadyAuto,
    NexIdPalette palette,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: palette.surfaceAccent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: palette.border),
          ),
          child: Icon(Icons.tune_outlined, color: palette.primary, size: 20),
        ),
        const SizedBox(width: AppDimensions.spaceSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Optimizacion del dispositivo',
                style: AppTypography.bodyMedium.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                statusText,
                style: AppTypography.caption.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        StatusBadge(
          label: controller.optimizationStatusLabel,
          type: isReadyAuto ? BadgeType.confirmed : BadgeType.pending,
        ),
      ],
    );
  }

  Widget _buildBottomManagementBar(String hardwareNote, NexIdPalette palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceSmall, vertical: 6.0),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.memory_outlined, size: 16, color: palette.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Gestion de rendimiento: ${controller.activeAdaptiveLevel.label} · $hardwareNote',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(color: palette.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Elemento de categoria en la lista vertical ordenada de Configuracion.
class SettingsCategoryListTile extends StatelessWidget {
  const SettingsCategoryListTile({super.key, required this.section, required this.onTap});
  final SettingsSectionId section;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return InkWell(
      key: Key('settings_category_${section.name}'),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMedium, vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: palette.surfaceAccent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: palette.border),
              ),
              child: Icon(section.icon, size: 19, color: palette.primary),
            ),
            const SizedBox(width: AppDimensions.spaceSmall + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: AppTypography.bodySmall.copyWith(color: palette.textPrimary, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(section.subtitle, style: AppTypography.caption.copyWith(color: palette.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spaceXSmall),
            Icon(Icons.chevron_right, size: 20, color: palette.textSecondary),
          ],
        ),
      ),
    );
  }
}
