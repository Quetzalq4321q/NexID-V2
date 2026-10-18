import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Estado vacio interactivo y con vida visual para cuando no hay datos disponibles.
/// Evita sensacion de pantalla muerta o congelada proporcionando contexto y accion.
class EmptyState extends StatefulWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onAction,
    this.icon = AppIcons.emptyInbox,
    this.isLively = true,
  });

  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;
  final bool isLively;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  AnimationController? _animController;
  Animation<double>? _pulseAnim;

  @override
  void initState() {
    super.initState();
    if (widget.isLively) {
      _initPulse();
    }
  }

  void _initPulse() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..forward();
    _pulseAnim = Tween<double>(begin: 0.90, end: 1.0).animate(
      CurvedAnimation(parent: _animController!, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLarge,
          vertical: AppDimensions.spaceXLarge,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLivelyIcon(palette, reduceMotion),
            const SizedBox(height: AppDimensions.spaceMedium),
            if (widget.title != null) ...[
              Text(
                widget.title!,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXSmall),
            ],
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: palette.textSecondary,
              ),
            ),
            if (widget.actionLabel != null && widget.onAction != null) ...[
              const SizedBox(height: AppDimensions.spaceLarge),
              OutlinedButton.icon(
                onPressed: widget.onAction,
                icon: const Icon(AppIcons.refresh, size: 16),
                label: Text(widget.actionLabel!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.primary,
                  side: BorderSide(color: palette.primary.withAlpha(100)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radius),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceMedium,
                    vertical: 12.0,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLivelyIcon(NexIdPalette palette, bool reduceMotion) {
    final Widget iconBadge = Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: palette.surfaceAccent,
        shape: BoxShape.circle,
        border: Border.all(color: palette.border, width: 1.5),
      ),
      child: Icon(
        widget.icon,
        size: 32.0,
        color: palette.primary,
      ),
    );

    if (!widget.isLively || reduceMotion || _pulseAnim == null) {
      return iconBadge;
    }

    return ScaleTransition(
      scale: _pulseAnim!,
      child: iconBadge,
    );
  }
}
