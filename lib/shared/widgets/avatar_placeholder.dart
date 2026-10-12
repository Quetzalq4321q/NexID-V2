import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

/// Marcador visual geometrico para fotos de perfil segun agent/03_DISENO.md.
/// No utiliza emojis ni decoraciones excesivas.
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: AppTypography.titleMedium.copyWith(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
