import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/avatar_placeholder.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/kpi_summary_row.dart';
import '../../../../shared/widgets/skeleton/module_skeletons.dart';
import '../../../../shared/widgets/skeleton/shimmer_skeleton.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/student_models.dart';
import '../controllers/students_controller.dart';
import 'student_full_profile_page.dart';

/// Pantalla 3: Directorio de alumnos con filtros avanzados, KPIs, Skeleton
/// Loading y acceso al expediente integral por pestañas.
class StudentsPage extends StatelessWidget {
  const StudentsPage({
    super.key,
    required this.controller,
  });

  final StudentsController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final NexIdPalette palette = NexIdPalette.of(context);
        final List<Student> students = controller.students;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spaceLarge,
                    AppDimensions.spaceMedium,
                    AppDimensions.spaceLarge,
                    AppDimensions.spaceSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      controller.isLoading && !controller.hasCachedData
                          ? const KpiSummarySkeleton()
                          : KpiSummaryRow(
                              items: <(String, String)>[
                                ('Padron Local', '${controller.totalCount}'),
                                ('Regulares', '${controller.regularCount}'),
                                (
                                  'Asistencia Media',
                                  '${controller.averageAttendanceRate}%'
                                ),
                              ],
                            ),
                      const SizedBox(height: AppDimensions.spaceMedium),
                      _buildSearchAndRefreshRow(palette),
                      const SizedBox(height: AppDimensions.spaceSmall),
                      _buildStatusFilterChips(),
                    ],
                  ),
                ),
                Divider(height: 1, color: palette.border),
                Expanded(
                  child: DataStateBoundary(
                    isLoading: controller.isLoading,
                    hasData: students.isNotEmpty,
                    errorMessage: controller.errorMessage,
                    onRetry: () => controller.loadStudents(forceSkeleton: true),
                    skeleton: const StudentListSkeleton(),
                    emptyState: EmptyState(
                      message:
                          'No se encontraron alumnos para la busqueda o filtro aplicado.',
                      actionLabel: 'Limpiar filtros',
                      onAction: controller.clearFilters,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
                      itemCount: students.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppDimensions.spaceSmall),
                      itemBuilder: (BuildContext context, int index) {
                        return _buildStudentCard(
                          context,
                          students[index],
                          palette,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndRefreshRow(NexIdPalette palette) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: AppTypography.bodyMedium.copyWith(color: palette.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Buscar por nombre, codigo, DNI o carrera...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: controller.setSearchQuery,
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSmall),
        IconButton(
          tooltip: 'Recargar padron con Skeleton',
          onPressed: () => controller.loadStudents(forceSkeleton: true),
          icon: Icon(Icons.refresh_outlined, color: palette.primary),
        ),
      ],
    );
  }

  Widget _buildStatusFilterChips() {
    const List<(String?, String)> filters = <(String?, String)>[
      (null, 'Todos'),
      ('Matriculado Regular', 'Matriculados Regulares'),
      ('Reserva de Matricula', 'En Reserva'),
    ];

    return Wrap(
      spacing: 8.0,
      runSpacing: 6.0,
      children: filters.map(((String?, String) item) {
        final bool isSelected = controller.statusFilter == item.$1;
        return ChoiceChip(
          label: Text(item.$2),
          selected: isSelected,
          onSelected: (_) => controller.setStatusFilter(item.$1),
        );
      }).toList(),
    );
  }

  Widget _buildStudentCard(
    BuildContext context,
    Student student,
    NexIdPalette palette,
  ) {
    final bool isRegular = student.status.toLowerCase().contains('regular');
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => StudentFullProfilePage(student: student),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          child: Row(
            children: [
              AvatarPlaceholder(name: student.fullName, size: 48),
              const SizedBox(width: AppDimensions.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: AppTypography.bodyMedium.copyWith(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${student.code} · ${student.career}',
                      style: AppTypography.bodySmall.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.academicPeriod} (${student.academicCycle}) · Asistencia: ${student.attendanceRate}%',
                      style: AppTypography.caption.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(
                    label: student.status,
                    type: isRegular ? BadgeType.confirmed : BadgeType.pending,
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: palette.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
