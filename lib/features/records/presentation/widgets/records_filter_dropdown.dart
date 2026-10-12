import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
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
    final NexIdPalette palette = NexIdPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.tune,
            size: 20,
            color: palette.primary,
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RecordFilterCriteria>(
                value: controller.filterCriteria,
                isExpanded: true,
                dropdownColor: palette.surfaceElevated,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: palette.textPrimary,
                ),
                items: RecordFilterCriteria.values.map((RecordFilterCriteria criteria) {
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
                            ? palette.primary
                            : palette.textPrimary,
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
              color: palette.textSecondary,
            ),
            tooltip: controller.sortDescending
                ? 'Mas recientes primero'
                : 'Mas antiguos primero',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: controller.toggleSortOrder,
          ),
          IconButton(
            icon: Icon(
              Icons.refresh_outlined,
              size: 18,
              color: palette.primary,
            ),
            tooltip: 'Actualizar registros',
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => controller.loadRecords(forceSkeleton: true),
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
