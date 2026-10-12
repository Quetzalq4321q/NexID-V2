import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../session/domain/session_models.dart';
import '../../../session/presentation/widgets/google_account_sheet.dart';

/// Tarjeta de perfil del operador con estilo de cuenta Google para la pantalla de ajustes.
class OperatorProfileCard extends StatelessWidget {
  const OperatorProfileCard({
    super.key,
    required this.user,
    required this.placeName,
    required this.onLogout,
  });

  final OperatorUser user;
  final String placeName;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final String initial = user.displayName.isNotEmpty
        ? user.displayName.trim()[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surfaceAccent, width: 2.0),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.background,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '@${user.username} · ${user.role.label}',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              side: const BorderSide(color: AppColors.border),
            ),
            onPressed: () => GoogleAccountSheet.show(
              context,
              user: user,
              activePlaceName: placeName,
              onLogout: onLogout,
            ),
            child: const Text('Ver info'),
          ),
        ],
      ),
    );
  }
}
