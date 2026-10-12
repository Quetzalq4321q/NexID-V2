import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/settings_models.dart';
import '../controllers/settings_controller.dart';

/// Tarjeta superior de gestion de apariencia con deteccion automatica del SO
/// y selector de tres modos independientes (Claro, Oscuro, Automatico).
class ThemeAppearanceCard extends StatelessWidget {
  const ThemeAppearanceCard({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final bool isOsDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bool isEffectiveDark = controller.isEffectiveDark(context);

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
            _buildHeader(palette, isOsDark, isEffectiveDark),
            const SizedBox(height: AppDimensions.spaceMedium),
            _buildModeOptionsRow(palette),
            const SizedBox(height: AppDimensions.spaceSmall),
            _buildActiveSummaryBar(palette, isOsDark, isEffectiveDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    NexIdPalette palette,
    bool isOsDark,
    bool isEffectiveDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: palette.surfaceAccent,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            border: Border.all(color: palette.border),
          ),
          child: Icon(
            isEffectiveDark
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            color: palette.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Apariencia y Tema del Sistema',
                style: AppTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Modo claro y oscuro con tokens semanticos independientes',
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        StatusBadge(
          label: isOsDark ? 'SO: Oscuro' : 'SO: Claro',
          type: BadgeType.info,
        ),
      ],
    );
  }

  Widget _buildModeOptionsRow(NexIdPalette palette) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: AppThemePreference.values.map((AppThemePreference mode) {
        return SizedBox(
          width: 112,
          child: _ThemeOptionTile(
            mode: mode,
            isSelected: controller.themePreference == mode,
            palette: palette,
            onTap: () => controller.setThemePreference(mode),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActiveSummaryBar(
    NexIdPalette palette,
    bool isOsDark,
    bool isEffectiveDark,
  ) {
    final String activeThemeLabel =
        isEffectiveDark ? 'Oscuro activo' : 'Claro activo';
    final String osDetectedLabel = isOsDark
        ? 'Sistema operativo detectado en modo oscuro'
        : 'Sistema operativo detectado en modo claro';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSmall,
        vertical: AppDimensions.spaceXSmall,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, size: 16, color: palette.textSecondary),
          const SizedBox(width: AppDimensions.spaceXSmall),
          Expanded(
            child: Text(
              '$osDetectedLabel • $activeThemeLabel',
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.mode,
    required this.isSelected,
    required this.palette,
    required this.onTap,
  });

  final AppThemePreference mode;
  final bool isSelected;
  final NexIdPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (mode) {
      AppThemePreference.light => Icons.wb_sunny_outlined,
      AppThemePreference.dark => Icons.nights_stay_outlined,
      AppThemePreference.system => Icons.brightness_auto_outlined,
    };

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Tema ${mode.label}. ${mode.description}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceSmall,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: isSelected ? palette.surfaceAccent : palette.surfaceSubtle,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            border: Border.all(
              color: isSelected ? palette.primary : palette.border,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? palette.primary : palette.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                mode.label,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? palette.primary : palette.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
