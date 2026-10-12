import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

/// Tipo de estado para el badge.
enum BadgeType {
  pending,
  confirmed,
  review,
  info,
}

/// Indicador visual compacto para estados segun agent/23_CACHE_USABLE.md.
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
    final (Color bgColor, Color textColor) = switch (type) {
      BadgeType.pending => (
          AppColors.warning.withAlpha(25),
          AppColors.warning,
        ),
      BadgeType.confirmed => (
          AppColors.success.withAlpha(25),
          AppColors.success,
        ),
      BadgeType.review => (
          AppColors.error.withAlpha(25),
          AppColors.error,
        ),
      BadgeType.info => (
          AppColors.surfaceAccent,
          AppColors.textPrimary,
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
          color: type == BadgeType.info ? AppColors.border : textColor,
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
