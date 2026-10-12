import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Estado vacio claro sin pantallas de relleno (agent/03_DISENO.md).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: palette.textSecondary,
            ),
            const SizedBox(height: AppDimensions.spaceMedium),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.spaceLarge),
              OutlinedButton(
                onPressed: onAction,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: palette.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.buttonText.copyWith(
                    color: palette.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
