import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/report_models.dart';

/// Tarjeta que representa el estado y descarga de un job de reporte.
class ReportJobCard extends StatelessWidget {
  const ReportJobCard({
    super.key,
    required this.job,
  });

  final ReportJob job;

  @override
  Widget build(BuildContext context) {
    final BadgeType badgeType = switch (job.status) {
      ReportStatus.queued => BadgeType.pending,
      ReportStatus.processing => BadgeType.info,
      ReportStatus.completed => BadgeType.confirmed,
      ReportStatus.failed => BadgeType.review,
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
                  '${job.format} · ${DateFormatter.formatDateTime(job.createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption,
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
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Filtro: ${job.filterPlace}',
            style: AppTypography.bodySmall,
          ),
          if (job.status == ReportStatus.completed) ...[
            const SizedBox(height: AppDimensions.spaceMedium),
            SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Descargar Archivo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
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
        ],
      ),
    );
  }
}
