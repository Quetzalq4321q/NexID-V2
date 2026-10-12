import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

/// Boton secundario de accion conforme a agent/03_DISENO.md.
/// Superficie de morado claro con texto oscuro garantizando contraste.
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
    return SizedBox(
      height: AppDimensions.minTouchTarget,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMedium,
                ),
              ),
              child: _buildContent(),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceAccent,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radius),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceMedium,
                ),
              ),
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: AppDimensions.spaceSmall),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.buttonText.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
