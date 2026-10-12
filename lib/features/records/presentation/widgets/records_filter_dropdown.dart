import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../controllers/records_controller.dart';

/// Barra con desplegable unificado de opciones y filtros para eventos.
class RecordsFilterDropdown extends StatelessWidget {
  const RecordsFilterDropdown({
    super.key,
    required this.controller,
    required this.totalCount,
  });

  final RecordsController controller;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLarge,
        vertical: AppDimensions.spaceSmall,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.tune,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RecordFilterCriteria>(
                value: controller.filterCriteria,
                isExpanded: true,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textPrimary,
                ),
                items: RecordFilterCriteria.values.map((criteria) {
                  final bool isSelected = criteria == controller.filterCriteria;
                  return DropdownMenuItem<RecordFilterCriteria>(
                    value: criteria,
                    child: Text(
                      criteria.label,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (RecordFilterCriteria? val) {
                  if (val != null) {
                    controller.setFilterCriteria(val);
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              controller.sortDescending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 18,
              color: AppColors.textSecondary,
            ),
            tooltip: controller.sortDescending
                ? 'Mas recientes primero'
                : 'Mas antiguos primero',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => controller.toggleSortOrder(),
          ),
          const SizedBox(width: 4),
          StatusBadge(
            label: '$totalCount',
            type: BadgeType.info,
          ),
        ],
      ),
    );
  }
}
