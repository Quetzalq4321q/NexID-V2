import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reports/presentation/pages/pdf_preview_page.dart';
import '../../../reports/presentation/widgets/pdf_a4_sheet_widget.dart';
import '../../domain/record_models.dart';

/// Hoja modal auditable con el detalle completo e historial de cambios de un registro.
class RecordDetailSheet extends StatelessWidget {
  const RecordDetailSheet({
    super.key,
    required this.record,
  });

  final EventRecord record;

  static Future<void> show(BuildContext context, EventRecord record) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => RecordDetailSheet(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final BadgeType badgeType = switch (record.syncStatus) {
      RecordSyncStatus.pending => BadgeType.pending,
      RecordSyncStatus.confirmed => BadgeType.confirmed,
      RecordSyncStatus.reviewRequired => BadgeType.review,
    };

    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        border: Border.all(color: palette.border),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceLarge,
        AppDimensions.spaceMedium,
        AppDimensions.spaceLarge,
        AppDimensions.spaceLarge,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Detalle Auditable de Registro ${record.id}',
                      style: AppTypography.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: palette.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children: [
                  StatusBadge(label: record.syncStatus.label, type: badgeType),
                  StatusBadge(
                    label: 'Operacion: ${record.eventType.label}',
                    type: BadgeType.info,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              _buildMetadataBox(palette),
              const SizedBox(height: AppDimensions.spaceMedium),
              Text(
                'Historial de Cambios y Sincronizacion',
                style: AppTypography.caption.copyWith(
                  color: palette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              ...record.changeHistory.map(
                (RecordChangeEntry entry) => _buildHistoryItem(entry, palette),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                label: const Text('Exportar / Vista Previa PDF (A4)'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PdfPreviewPage(
                        initialTemplate: PdfTemplateType.recordsReport,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataBox(NexIdPalette palette) {
    final List<(String, String)> fields = <(String, String)>[
      ('Identificador', '${record.id} (${record.idempotencyKey})'),
      ('Alumno', '${record.studentName} (${record.studentCode})'),
      ('Punto de Control', '${record.placeName} (${record.placeId})'),
      ('Usuario Responsable', record.operatorName),
      ('Medio de Lectura', record.medium.label),
      ('Fecha de Creacion', DateFormatter.formatDateTime(record.timestamp)),
      ('Ultima Modificacion', DateFormatter.formatDateTime(record.lastModifiedAt)),
      ('Intentos de Cola', '${record.attemptCount} pasadas'),
      ('Info Relacionada', record.relatedInfo),
    ];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        children: fields.map(((String, String) item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 135,
                  child: Text(
                    item.$1,
                    style: AppTypography.caption.copyWith(
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    item.$2,
                    style: AppTypography.bodySmall.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryItem(RecordChangeEntry entry, NexIdPalette palette) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history, size: 16, color: palette.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.action,
                  style: AppTypography.bodySmall.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${entry.actor} · ${entry.timestampLabel}',
                  style: AppTypography.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
