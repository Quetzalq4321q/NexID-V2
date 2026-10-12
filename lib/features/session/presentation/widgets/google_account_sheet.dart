import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
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
    final String initial = user.displayName.isNotEmpty
        ? user.displayName.trim()[0].toUpperCase()
        : 'U';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
              // Barra superior con tirador y boton cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 32),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Cerrar',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spaceSmall),

              // Circulo de cuenta de Google
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surfaceAccent, width: 3.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.background,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMedium),

              // Nombre de usuario y rol
              Text(
                user.displayName,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '@${user.username}',
                style: AppTypography.bodySmall,
              ),
              const SizedBox(height: AppDimensions.spaceSmall),
              StatusBadge(
                label: 'Rol: ${user.role.label}',
                type: BadgeType.confirmed,
                maxWidth: 220,
              ),
              const SizedBox(height: AppDimensions.spaceLarge),

              // Tarjeta informativa con punto de control y permisos
              _buildInfoSection(),
              const SizedBox(height: AppDimensions.spaceLarge),

              // Boton de Ajustes
              if (onOpenSettings != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.settings_outlined, size: 18),
                    label: const Text('Ajustes del Sistema'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onOpenSettings!();
                    },
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSmall),
              ],

              // Boton de Cerrar Sesion
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton.icon(
                  icon: const Icon(Icons.logout_outlined, size: 18),
                  label: const Text('Cerrar Sesion'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.surfaceAccent,
                    foregroundColor: AppColors.error,
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

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Punto de Control: $activePlaceName',
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: AppDimensions.spaceMedium, color: AppColors.border),
          const Text('Permisos asignados:', style: AppTypography.caption),
          const SizedBox(height: 4),
          _buildPermissionRow('Lectura de credenciales NFC (Ficha completa)'),
          _buildPermissionRow('Lectura de codigos QR (Proyeccion parcial)'),
          if (user.canRegisterEvents)
            _buildPermissionRow('Registro de ingreso, salida y control'),
          if (user.canEditStudents)
            _buildPermissionRow('Edicion autorizada de datos de alumnos'),
        ],
      ),
    );
  }

  Widget _buildPermissionRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, size: 14, color: AppColors.success),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text, style: AppTypography.bodySmall),
          ),
        ],
      ),
    );
  }
}
