import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Define los tres niveles de ancho estipulados en agent/08_ADAPTABILIDAD.md.
enum ScreenCategory {
  compact,
  medium,
  large,
}

/// Helper para composiciones adaptables segun el ancho disponible.
abstract final class ResponsiveLayout {
  static ScreenCategory getCategory(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < AppDimensions.breakpointMedium) {
      return ScreenCategory.compact;
    } else if (width < AppDimensions.breakpointLarge) {
      return ScreenCategory.medium;
    } else {
      return ScreenCategory.large;
    }
  }

  static bool isCompact(BuildContext context) =>
      getCategory(context) == ScreenCategory.compact;

  static bool isMedium(BuildContext context) =>
      getCategory(context) == ScreenCategory.medium;

  static bool isLarge(BuildContext context) =>
      getCategory(context) == ScreenCategory.large;
}

/// Widget constructor para renderizar composiciones segun el tamano.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.compact,
    this.medium,
    this.large,
  });

  final WidgetBuilder compact;
  final WidgetBuilder? medium;
  final WidgetBuilder? large;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= AppDimensions.breakpointLarge &&
            large != null) {
          return large!(context);
        }
        if (constraints.maxWidth >= AppDimensions.breakpointMedium &&
            medium != null) {
          return medium!(context);
        }
        return compact(context);
      },
    );
  }
}
