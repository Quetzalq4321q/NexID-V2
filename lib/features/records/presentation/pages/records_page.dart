import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../domain/record_models.dart';
import '../controllers/records_controller.dart';
import '../widgets/records_filter_dropdown.dart';

/// Pantalla 4: Lista filtrada de eventos de asistencia y control.
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
        final List<EventRecord> records = controller.records;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Desplegable unificado de opciones y filtros
                RecordsFilterDropdown(
                  controller: controller,
                  totalCount: records.length,
                ),
                const Divider(height: 1, color: AppColors.border),

                // Lista de eventos
                Expanded(
                  child: controller.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        )
                      : records.isEmpty
                          ? const EmptyState(
                              message:
                                  'No se encontraron registros de eventos para el filtro seleccionado.',
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(
                                AppDimensions.spaceLarge,
                              ),
                              itemCount: records.length,
                              separatorBuilder: (_, _) => const SizedBox(
                                height: AppDimensions.spaceSmall,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return _buildRecordItem(records[index]);
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecordItem(EventRecord record) {
    final BadgeType badgeType = switch (record.syncStatus) {
      RecordSyncStatus.pending => BadgeType.pending,
      RecordSyncStatus.confirmed => BadgeType.confirmed,
      RecordSyncStatus.reviewRequired => BadgeType.review,
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${record.eventType.label} · ${DateFormatter.formatDateTime(record.timestamp)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSmall),
              StatusBadge(
                label: record.syncStatus.label,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            record.studentName,
            style: AppTypography.titleMedium.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            'Codigo: ${record.studentCode} | ${record.placeName}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Row(
            children: [
              Icon(
                record.medium == ReadingMedium.nfc
                    ? Icons.nfc
                    : Icons.qr_code,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  record.medium.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
