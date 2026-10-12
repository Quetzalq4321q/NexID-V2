import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/avatar_placeholder.dart';
import '../controllers/students_controller.dart';

/// Pantalla 3: Directorio de alumnos matriculados y busqueda.
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
        final students = controller.students;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre, codigo o carrera...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (String val) {
                    controller.setSearchQuery(val);
                  },
                ),
                const SizedBox(height: AppDimensions.spaceMedium),
                Expanded(
                  child: ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppDimensions.spaceSmall),
                    itemBuilder: (BuildContext context, int index) {
                      final student = students[index];
                      return Container(
                        padding:
                            const EdgeInsets.all(AppDimensions.spaceMedium),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            AvatarPlaceholder(
                              name: student.fullName,
                              size: 48,
                            ),
                            const SizedBox(width: AppDimensions.spaceMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student.fullName,
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${student.code} · ${student.career}',
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
