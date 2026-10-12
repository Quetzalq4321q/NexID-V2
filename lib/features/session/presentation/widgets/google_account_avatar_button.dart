import 'package:flutter/material.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../domain/session_models.dart';

/// Boton circular de cuenta de usuario con estilo de cuenta Google para el AppBar.
class GoogleAccountAvatarButton extends StatelessWidget {
  const GoogleAccountAvatarButton({
    super.key,
    required this.user,
    required this.onTap,
    this.size = 36.0,
  });

  final OperatorUser user;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final String initial = user.displayName.isNotEmpty
        ? user.displayName.trim()[0].toUpperCase()
        : 'U';

    return Tooltip(
      message: 'Cuenta de ${user.displayName} (${user.role.label})',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: palette.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: palette.surfaceAccent,
                width: 2.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: AppTypography.caption.copyWith(
                color: palette.onPrimary,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.44,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
