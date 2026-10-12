import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import '../../core/theme/nexid_palette.dart';

/// Fila reutilizable de indicadores clave (KPIs) para cabeceras de modulos.
class KpiSummaryRow extends StatelessWidget {
  const KpiSummaryRow({
    super.key,
    required this.items,
  });

  final List<(String label, String value)> items;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Row(
      children: List<Widget>.generate(items.length, (int index) {
        final (String label, String value) = items[index];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < items.length - 1 ? 8.0 : 0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSmall,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                border: Border.all(color: palette.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: palette.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTypography.titleMedium.copyWith(
                      color: palette.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
