import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';

/// Tarjeta para visualizar un campo de dato del estudiante de forma adaptable.
class StudentFieldCard extends StatelessWidget {
  const StudentFieldCard({
    super.key,
    required this.label,
    required this.value,
    this.isDimmed = false,
  });

  final String label;
  final String value;
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isDimmed ? palette.textDisabled : palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
