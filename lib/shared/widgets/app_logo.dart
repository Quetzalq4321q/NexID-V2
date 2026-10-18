import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/theme/nexid_palette.dart';

/// Emblema e icono oficial de NexID con soporte para estado estatico o pulso de vida.
/// Mantiene geometria institucional nitida con el azul solido #1D4ED8.
class NexIdAppLogo extends StatefulWidget {
  const NexIdAppLogo({
    super.key,
    this.size = 48.0,
    this.isLively = false,
    this.borderRadius,
  });

  final double size;
  final bool isLively;
  final double? borderRadius;

  @override
  State<NexIdAppLogo> createState() => _NexIdAppLogoState();
}

class _NexIdAppLogoState extends State<NexIdAppLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnim;

  @override
  void initState() {
    super.initState();
    if (widget.isLively) {
      _initAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant NexIdAppLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLively && _controller == null) {
      _initAnimation();
    } else if (!widget.isLively && _controller != null) {
      _controller?.dispose();
      _controller = null;
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final double radius = widget.borderRadius ?? (widget.size * 0.22);
    final double iconSize = widget.size * 0.58;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    final Widget core = Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: palette.isDark ? AppColors.surfaceAccentDark : AppColors.surfaceAccent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(palette.isDark ? 50 : 35),
            blurRadius: widget.size * 0.25,
            offset: Offset(0, widget.size * 0.08),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          AppIcons.appEmblem,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );

    if (!widget.isLively || reduceMotion || _scaleAnim == null) {
      return core;
    }

    return ScaleTransition(
      scale: _scaleAnim!,
      child: core,
    );
  }
}
