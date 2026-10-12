import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/upload_models.dart';

/// Tarjeta que representa un archivo en cola o proceso de subida.
class UploadItemCard extends StatelessWidget {
  const UploadItemCard({
    super.key,
    required this.item,
  });

  final UploadFileItem item;

  @override
  Widget build(BuildContext context) {
    final BadgeType badgeType = switch (item.status) {
      UploadStatus.idle => BadgeType.info,
      UploadStatus.uploading => BadgeType.pending,
      UploadStatus.completed => BadgeType.confirmed,
      UploadStatus.error => BadgeType.review,
    };

    final String statusLabel = switch (item.status) {
      UploadStatus.idle => 'Listo',
      UploadStatus.uploading =>
        '${(item.progress * 100).toInt()}% subiendo',
      UploadStatus.completed => 'Subido con exito',
      UploadStatus.error => 'Rechazado',
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: item.status == UploadStatus.error
              ? AppColors.error
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.fileName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              StatusBadge(
                label: statusLabel,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${item.purpose} · ${item.formattedSize}',
            style: AppTypography.bodySmall,
          ),
          if (item.status == UploadStatus.uploading) ...[
            const SizedBox(height: AppDimensions.spaceSmall),
            LinearProgressIndicator(
              value: item.progress,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
          if (item.errorMessage != null) ...[
            const SizedBox(height: AppDimensions.spaceSmall),
            Text(
              item.errorMessage!,
              style: AppTypography.caption.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
