import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/theme/nexid_palette.dart';
import 'shimmer_skeleton.dart';

/// Skeletons personalizados adaptados a la estructura real de cada modulo
/// (Alumnos, Registros, KPIs y Ficha de Alumno).
class KpiSummarySkeleton extends StatelessWidget {
  const KpiSummarySkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Row(
      children: List<Widget>.generate(itemCount, (int index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < itemCount - 1 ? 8.0 : 0),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spaceSmall),
              decoration: BoxDecoration(
                color: palette.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                border: Border.all(color: palette.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 48, height: 12),
                  SizedBox(height: 6),
                  ShimmerBox(width: 32, height: 18),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Skeleton estructurado para la lista de padron de alumnos.
class StudentListSkeleton extends StatelessWidget {
  const StudentListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppDimensions.spaceSmall),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            border: Border.all(color: palette.border),
          ),
          child: const Row(
            children: [
              ShimmerBox(height: 44, isCircle: true),
              SizedBox(width: AppDimensions.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 170, height: 15),
                    SizedBox(height: 6),
                    ShimmerBox(width: 130, height: 12),
                    SizedBox(height: 6),
                    ShimmerBox(width: 95, height: 11),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.spaceSmall),
              ShimmerBox(width: 72, height: 24, borderRadius: 6),
            ],
          ),
        );
      },
    );
  }
}

/// Skeleton estructurado para el listado auditable de registros.
class RecordListSkeleton extends StatelessWidget {
  const RecordListSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AppDimensions.spaceSmall),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            border: Border.all(color: palette.border),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 40, height: 40, borderRadius: 8),
              SizedBox(width: AppDimensions.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 180, height: 15),
                    SizedBox(height: 6),
                    ShimmerBox(width: 140, height: 12),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ShimmerBox(width: 70, height: 11),
                        SizedBox(width: 12),
                        ShimmerBox(width: 85, height: 11),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppDimensions.spaceSmall),
              ShimmerBox(width: 82, height: 24, borderRadius: 6),
            ],
          ),
        );
      },
    );
  }
}
