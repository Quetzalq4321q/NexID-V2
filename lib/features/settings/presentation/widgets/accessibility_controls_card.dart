import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../domain/settings_models.dart';
import '../controllers/settings_controller.dart';

/// Tarjeta de controles de accesibilidad WCAG 2.2 (escala de fuente, contraste,
/// reduccion de movimiento y soporte de lector de pantalla).
class AccessibilityControlsCard extends StatelessWidget {
  const AccessibilityControlsCard({
    super.key,
    required this.controller,
  });

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFontScaleSection(palette),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            secondary: Icon(
              Icons.contrast_outlined,
              color: palette.textSecondary,
            ),
            title: Text(
              'Alto contraste (WCAG 2.2 AAA)',
              style: AppTypography.bodyMedium.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Refuerza bordes, textos e indicadores para baja vision',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            value: controller.highContrast,
            onChanged: controller.toggleHighContrast,
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            secondary: Icon(
              Icons.motion_photos_off_outlined,
              color: palette.textSecondary,
            ),
            title: Text(
              'Reducir animaciones y movimiento',
              style: AppTypography.bodyMedium.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Desactiva efectos shimmer, transiciones largas y microinteracciones',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            value: controller.reduceMotion,
            onChanged: controller.toggleReduceMotion,
          ),
          Divider(height: 1, color: palette.border),
          SwitchListTile(
            secondary: Icon(
              Icons.record_voice_over_outlined,
              color: palette.textSecondary,
            ),
            title: Text(
              'Compatibilidad extendida con lector de pantalla',
              style: AppTypography.bodyMedium.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Agrega etiquetas descriptivas y anuncios de estado en vivo',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
            value: controller.screenReaderOptimized,
            onChanged: controller.toggleScreenReaderOptimized,
          ),
        ],
      ),
    );
  }

  Widget _buildFontScaleSection(NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.format_size_outlined,
                size: 20,
                color: palette.textSecondary,
              ),
              const SizedBox(width: AppDimensions.spaceSmall),
              Expanded(
                child: Text(
                  'Tamano de fuente en toda la aplicacion',
                  style: AppTypography.bodyMedium.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                controller.fontScalePreset.percentageLabel,
                style: AppTypography.bodySmall.copyWith(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: FontScalePreset.values.map((FontScalePreset preset) {
              final bool isSelected = controller.fontScalePreset == preset;
              return ChoiceChip(
                label: Text('${preset.percentageLabel} (${preset.label})'),
                selected: isSelected,
                onSelected: (_) => controller.setFontScalePreset(preset),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
