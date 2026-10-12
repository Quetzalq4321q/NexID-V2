import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../controllers/sync_controller.dart';
import '../../domain/sync_models.dart';

/// Banner compacto de sincronizacion segun agent/23_CACHE_USABLE.md.
class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({
    super.key,
    required this.controller,
  });

  final SyncController controller;

  @override
  Widget build(BuildContext context) {
    final SyncStats stats = controller.stats;
    final SyncProcessState state = controller.state;

    final Color bannerColor = switch (state) {
      SyncProcessState.reviewRequired => AppColors.error.withAlpha(20),
      SyncProcessState.hasPending ||
      SyncProcessState.syncing =>
        AppColors.warning.withAlpha(20),
      SyncProcessState.idle => AppColors.surface,
    };

    final Color iconColor = switch (state) {
      SyncProcessState.reviewRequired => AppColors.error,
      SyncProcessState.hasPending ||
      SyncProcessState.syncing =>
        AppColors.warning,
      SyncProcessState.idle => AppColors.success,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: AppDimensions.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: bannerColor,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            state == SyncProcessState.syncing
                ? Icons.sync
                : Icons.cloud_done_outlined,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            child: Text(
              stats.pendingCount > 0
                  ? '${stats.pendingCount} pendientes de enviar · Act. ${DateFormatter.formatTimeOnly(stats.lastSyncTime)}'
                  : 'Datos locales al dia · ${DateFormatter.formatTimeOnly(stats.lastSyncTime)}',
              style: AppTypography.caption.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (stats.pendingCount > 0)
            SizedBox(
              height: 32,
              child: TextButton(
                onPressed: controller.isSyncing
                    ? null
                    : () => controller.syncNow(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  foregroundColor: AppColors.primary,
                ),
                child: Text(
                  controller.isSyncing ? 'Enviando...' : 'Sincronizar',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
