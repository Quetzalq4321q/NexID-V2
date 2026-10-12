import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/session_models.dart';

/// Modal estilo cuenta de Google que presenta la informacion y estado del operador.
class GoogleAccountSheet extends StatelessWidget {
  const GoogleAccountSheet({
    super.key,
    required this.user,
    required this.activePlaceName,
    required this.onLogout,
    this.onOpenSettings,
  });

  final OperatorUser user;
  final String activePlaceName;
  final VoidCallback onLogout;
  final VoidCallback? onOpenSettings;

  static Future<void> show(
    BuildContext context, {
    required OperatorUser user,
    required String activePlaceName,
    required VoidCallback onLogout,
    VoidCallback? onOpenSettings,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => GoogleAccountSheet(
        user: user,
        activePlaceName: activePlaceName,
        onLogout: onLogout,
        onOpenSettings: onOpenSettings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final String initial = user.displayName.isNotEmpty
        ? user.displayName.trim()[0].toUpperCase()
        : 'U';

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: palette.border,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: palette.textSecondary),
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: palette.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.surfaceAccent, width: 3.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: AppTypography.titleLarge.copyWith(
                    color: palette.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),
              Text(
                user.displayName,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '@${user.username}',
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              StatusBadge(
                label: 'Rol: ${user.role.label}',
                type: BadgeType.confirmed,
                maxWidth: 220,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),
              _buildInfoSection(palette),
              const SizedBox(height: AppDimensions.spaceLarge),
              if (onOpenSettings != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    label: const Text('Ajustes del Sistema'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.textPrimary,
                      side: BorderSide(color: palette.border),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onOpenSettings!();
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSmall),
              ],
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton.icon(
                  icon: const Icon(Icons.logout_outlined, size: 18),
                  label: const Text('Cerrar Sesion'),
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.errorSurface,
                    foregroundColor: palette.error,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onLogout();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(NexIdPalette palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: palette.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Punto de Control: $activePlaceName',
                  style: AppTypography.bodySmall.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Divider(height: AppDimensions.spaceMedium, color: palette.border),
          Text(
            'Permisos asignados:',
            style: AppTypography.caption.copyWith(color: palette.textSecondary),
          ),
          const SizedBox(height: 4),
          _buildPermissionRow('Lectura de credenciales NFC (Ficha completa)', palette),
          _buildPermissionRow('Lectura de codigos QR (Proyeccion parcial)', palette),
          if (user.canRegisterEvents)
            _buildPermissionRow('Registro de ingreso, salida y control', palette),
          if (user.canEditStudents)
            _buildPermissionRow('Edicion autorizada de datos de alumnos', palette),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String text, NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, size: 14, color: palette.success),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(color: palette.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
