import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/report_models.dart';
import '../pages/pdf_preview_page.dart';
import 'pdf_a4_sheet_widget.dart';

/// Tarjeta que representa el estado, vista previa A4 y descarga de un job de reporte.
class ReportJobCard extends StatelessWidget {
  const ReportJobCard({
    super.key,
    required this.job,
  });

  final ReportJob job;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final BadgeType badgeType = switch (job.status) {
      ReportStatus.queued => BadgeType.pending,
      ReportStatus.processing => BadgeType.info,
      ReportStatus.completed => BadgeType.confirmed,
      ReportStatus.failed => BadgeType.review,
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${job.format} · ${DateFormatter.formatDateTime(job.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSmall),
              StatusBadge(
                label: job.status.label,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            job.title,
            style: AppTypography.bodyMedium.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Filtro: ${job.filterPlace}',
            style: AppTypography.bodySmall.copyWith(
              color: palette.textSecondary,
            ),
          ),
          if (job.status == ReportStatus.completed) ...[
            const SizedBox(height: AppDimensions.spaceMedium),
            Wrap(
              spacing: AppDimensions.spaceSmall,
              runSpacing: AppDimensions.spaceSmall,
              children: [
                SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Vista Previa A4'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PdfPreviewPage(
                            initialTemplate: PdfTemplateType.recordsReport,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download_outlined, size: 16),
                    label: const Text('Descargar Archivo'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Descargando ${job.title}...'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
