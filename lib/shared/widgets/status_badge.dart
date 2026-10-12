import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Tipo de estado para el badge.
enum BadgeType {
  pending,
  confirmed,
  review,
  info,
}

/// Indicador visual compacto para estados adaptable a tema Claro/Oscuro.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.info,
    this.maxWidth = 135.0,
  });

  final String label;
  final BadgeType type;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final (Color bgColor, Color textColor, Color borderColor) = switch (type) {
      BadgeType.pending => (
          palette.warningSurface,
          palette.warning,
          palette.warning.withAlpha(140),
        ),
      BadgeType.confirmed => (
          palette.successSurface,
          palette.success,
          palette.success.withAlpha(140),
        ),
      BadgeType.review => (
          palette.errorSurface,
          palette.error,
          palette.error.withAlpha(140),
        ),
      BadgeType.info => (
          palette.surfaceAccent,
          palette.textPrimary,
          palette.border,
        ),
    };

    Widget badge = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSmall + 2,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (maxWidth != null) {
      badge = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        child: badge,
      );
    }

    return badge;
  }
}
