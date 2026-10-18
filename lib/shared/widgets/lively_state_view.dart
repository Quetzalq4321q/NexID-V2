import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';
import 'app_logo.dart';

/// Pantalla o vista de carga con vida visual activa y retroalimentacion clara.
/// Elimina bloqueos visuales o estados inertes mediante un indicador vivo y mensaje de estado.
class LivelyLoadingView extends StatelessWidget {
  const LivelyLoadingView({
    super.key,
    this.title = 'Cargando informacion...',
    this.subtitle = 'Accediendo a base de datos local y verificando estado',
    this.onCancel,
    this.cancelLabel = 'Cancelar',
  });

  final String title;
  final String subtitle;
  final VoidCallback? onCancel;
  final String cancelLabel;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceXLarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const NexIdAppLogo(size: 56, isLively: true),
              const SizedBox(height: AppDimensions.spaceLarge),
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXSmall),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              if (onCancel != null) ...[
                const SizedBox(height: AppDimensions.spaceLarge),
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(AppIcons.close, size: 16),
                  label: Text(cancelLabel),
                  style: TextButton.styleFrom(
                    foregroundColor: palette.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
