import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
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
    final NexIdPalette palette = NexIdPalette.of(context);
    final String initial = user.displayName.isNotEmpty
        ? user.displayName.trim()[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
              border: Border.all(color: palette.surfaceAccent, width: 2.0),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTypography.titleMedium.copyWith(
                color: palette.onPrimary,
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
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '@${user.username} · ${user.role.label}',
                  style: AppTypography.bodySmall.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              side: BorderSide(color: palette.border),
              foregroundColor: palette.textPrimary,
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
