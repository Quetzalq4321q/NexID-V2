import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/kpi_summary_row.dart';
import '../../../../shared/widgets/skeleton/module_skeletons.dart';
import '../../../../shared/widgets/skeleton/shimmer_skeleton.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/record_models.dart';
import '../controllers/records_controller.dart';
import '../widgets/record_detail_sheet.dart';
import '../widgets/records_filter_dropdown.dart';

/// Pantalla 4: Lista auditable y paginada de eventos de asistencia y control.
class RecordsPage extends StatelessWidget {
  const RecordsPage({
    super.key,
    required this.controller,
  });

  final RecordsController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final NexIdPalette palette = NexIdPalette.of(context);
        final List<EventRecord> visibleRecords = controller.paginatedRecords;
        final int totalFiltered = controller.records.length;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceLarge,
                    AppDimensions.spaceMedium,
                    AppDimensions.spaceLarge,
                    AppDimensions.spaceSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      controller.isLoading && !controller.hasCachedData
                          ? const KpiSummarySkeleton()
                          : KpiSummaryRow(
                              items: <(String, String)>[
                                ('Total Eventos', '${controller.totalCount}'),
                                ('Confirmados', '${controller.confirmedCount}'),
                                ('En Cola Local', '${controller.pendingCount}'),
                              ],
                            ),
                      const SizedBox(height: AppDimensions.spaceSmall),
                      TextField(
                        style: AppTypography.bodyMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          hintText:
                              'Buscar por ID, alumno, operador o punto...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: controller.setSearchQuery,
                      ),
                      const SizedBox(height: AppDimensions.spaceSmall),
                      RecordsFilterDropdown(
                        controller: controller,
                        totalCount: totalFiltered,
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: palette.border),
                Expanded(
                  child: DataStateBoundary(
                    isLoading: controller.isLoading,
                    hasData: visibleRecords.isNotEmpty,
                    errorMessage: controller.errorMessage,
                    onRetry: () => controller.loadRecords(forceSkeleton: true),
                    skeleton: const RecordListSkeleton(),
                    emptyState: EmptyState(
                      message:
                          'No se encontraron registros para el criterio o busqueda seleccionada.',
                      actionLabel: 'Restablecer filtros',
                      onAction: controller.clearFilters,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
                      itemCount: visibleRecords.length +
                          (controller.hasMorePages ? 1 : 0),
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppDimensions.spaceSmall),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == visibleRecords.length) {
                          return Center(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.expand_more, size: 18),
                              label: Text(
                                'Cargar mas registros (${visibleRecords.length} de $totalFiltered)',
                              ),
                              onPressed: controller.loadMore,
                            ),
                          );
                        }
                        return _buildRecordItem(
                          context,
                          visibleRecords[index],
                          palette,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordItem(
    BuildContext context,
    EventRecord record,
    NexIdPalette palette,
  ) {
    final BadgeType badgeType = switch (record.syncStatus) {
      RecordSyncStatus.pending => BadgeType.pending,
      RecordSyncStatus.confirmed => BadgeType.confirmed,
      RecordSyncStatus.reviewRequired => BadgeType.review,
    };

    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        onTap: () => RecordDetailSheet.show(context, record),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${record.id} · ${record.eventType.label} · ${DateFormatter.formatDateTime(record.timestamp)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSmall),
                  StatusBadge(label: record.syncStatus.label, type: badgeType),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              Text(
                record.studentName,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 16,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Codigo: ${record.studentCode} | ${record.placeName}',
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    record.medium == ReadingMedium.nfc
                        ? Icons.nfc
                        : Icons.qr_code,
                    size: 14,
                    color: palette.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${record.medium.label} · Resp: ${record.operatorName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.open_in_new,
                    size: 14,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
