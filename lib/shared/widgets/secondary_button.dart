import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Boton secundario de accion conforme a agent/03_DISENO.md y WCAG 2.2.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return SizedBox(
      height: AppDimensions.minTouchTarget,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.textPrimary,
                side: BorderSide(color: palette.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMedium,
                ),
              ),
              child: _buildContent(palette),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.surfaceAccent,
                foregroundColor: palette.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMedium,
                ),
              ),
              child: _buildContent(palette),
            ),
    );
  }

  Widget _buildContent(NexIdPalette palette) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: palette.textPrimary),
          const SizedBox(width: AppDimensions.spaceSmall),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.buttonText.copyWith(
              color: palette.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
