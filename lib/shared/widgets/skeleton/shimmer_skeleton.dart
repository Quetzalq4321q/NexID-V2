import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/theme/nexid_palette.dart';

/// Bloque de carga con efecto shimmer adaptable al tema activo (Claro/Oscuro)
/// y respetuoso de la preferencia de reduccion de movimiento (WCAG 2.2).
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 6.0,
    this.isCircle = false,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final bool disableAnimations = MediaQuery.disableAnimationsOf(context);

    if (disableAnimations) {
      return _buildContainer(palette.skeletonBase);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final Color animatedColor = Color.lerp(
              palette.skeletonBase,
              palette.skeletonHighlight,
              Curves.easeInOut.transform(_controller.value),
            ) ??
            palette.skeletonBase;
        return _buildContainer(animatedColor);
      },
    );
  }

  Widget _buildContainer(Color color) {
    return Container(
      width: widget.isCircle ? widget.height : widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: color,
        shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: widget.isCircle
            ? null
            : BorderRadius.circular(widget.borderRadius),
      ),
    );
  }
}

/// Contenedor reutilizable que gestiona estados diferenciados de carga inicial
/// (skeleton), actualizacion con cache, error con reintento y exito.
class DataStateBoundary extends StatelessWidget {
  const DataStateBoundary({
    super.key,
    required this.isLoading,
    required this.hasData,
    this.errorMessage,
    this.onRetry,
    required this.skeleton,
    required this.emptyState,
    required this.child,
  });

  final bool isLoading;
  final bool hasData;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget skeleton;
  final Widget emptyState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    Widget content;
    if (isLoading && !hasData) {
      content = KeyedSubtree(
        key: const ValueKey<String>('skeleton_loading'),
        child: skeleton,
      );
    } else if (errorMessage != null && !hasData) {
      content = KeyedSubtree(
        key: const ValueKey<String>('error_state'),
        child: _buildErrorView(palette),
      );
    } else if (!hasData) {
      content = KeyedSubtree(
        key: const ValueKey<String>('empty_state'),
        child: emptyState,
      );
    } else {
      content = KeyedSubtree(
        key: const ValueKey<String>('data_content'),
        child: Column(
          children: [
            if (isLoading)
              LinearProgressIndicator(
                minHeight: 2,
                color: palette.primary,
                backgroundColor: palette.surfaceSubtle,
              ),
            if (errorMessage != null) _buildCachedErrorBanner(palette),
            Expanded(child: child),
          ],
        ),
      );
    }

    if (reduceMotion) return content;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: content,
    );
  }

  Widget _buildCachedErrorBanner(NexIdPalette palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: AppDimensions.spaceXSmall,
      ),
      color: palette.warningSurface,
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 16, color: palette.warning),
          const SizedBox(width: AppDimensions.spaceSmall),
          Expanded(
            child: Text(
              'Mostrando datos en cache local. $errorMessage',
              style: AppTypography.caption.copyWith(color: palette.textPrimary),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorView(NexIdPalette palette) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 44, color: palette.error),
            const SizedBox(height: AppDimensions.spaceMedium),
            Text(
              'No se pudo completar la carga de datos',
              style: AppTypography.titleMedium.copyWith(
                color: palette.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spaceXSmall),
            Text(
              errorMessage ?? 'Error inesperado de lectura local.',
              style: AppTypography.bodySmall.copyWith(
                color: palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spaceMedium),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh_outlined, size: 18),
                label: const Text('Reintentar solicitud'),
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
