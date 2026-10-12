import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Marcador visual geometrico para fotos de perfil adaptable a tema Claro y Oscuro.
class AvatarPlaceholder extends StatelessWidget {
  const AvatarPlaceholder({
    super.key,
    required this.name,
    this.size = 64.0,
    this.imageUrl,
  });

  final String name;
  final double size;
  final String? imageUrl;

  String _getInitials(String fullName) {
    final List<String> parts =
        fullName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'ID';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: palette.surfaceAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: AppTypography.titleMedium.copyWith(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      ),
    );
  }
}
