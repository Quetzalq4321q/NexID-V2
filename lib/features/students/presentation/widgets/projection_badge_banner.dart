import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reading/domain/credential_models.dart';

/// Banner de nivel de autorizacion y proyeccion (NFC Ficha Completa vs QR Parcial).
class ProjectionBadgeBanner extends StatelessWidget {
  const ProjectionBadgeBanner({
    super.key,
    required this.credential,
  });

  final ResolvedCredential credential;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: credential.isFullProjection
            ? palette.surfaceAccent
            : palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Icon(
            credential.isFullProjection
                ? Icons.verified_user_outlined
                : Icons.visibility_outlined,
            color: palette.textPrimary,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            child: Text(
              credential.isFullProjection
                  ? 'Ficha Completa Autorizada (Lectura NFC)'
                  : 'Proyeccion Parcial Restringida (Lectura QR)',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spaceSmall),
          StatusBadge(
            label: credential.visibility.label,
            type: BadgeType.info,
          ),
        ],
      ),
    );
  }
}
