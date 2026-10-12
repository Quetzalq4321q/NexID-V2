import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/avatar_placeholder.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reports/presentation/pages/pdf_preview_page.dart';
import '../../../reports/presentation/widgets/pdf_a4_sheet_widget.dart';
import '../../domain/student_models.dart';
import '../widgets/student_profile_tabs.dart';
import 'student_edit_page.dart';

/// Expediente integral del alumno organizado por pestañas para evitar saturacion.
class StudentFullProfilePage extends StatelessWidget {
  const StudentFullProfilePage({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final AppDependencies deps = AppDependencies.of(context);
    final bool canEdit =
        deps.sessionController.currentUser?.canEditStudents ?? false;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: palette.background,
        appBar: AppBar(
          title: Text(
            'Expediente Integral de Alumno',
            style: AppTypography.titleMedium.copyWith(color: palette.textPrimary),
          ),
          backgroundColor: palette.surface,
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf_outlined, color: palette.primary),
              tooltip: 'Vista previa A4 PDF de Ficha',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PdfPreviewPage(
                      initialTemplate: PdfTemplateType.studentFicha,
                      initialStudent: student,
                    ),
                  ),
                );
              },
            ),
            if (canEdit)
              IconButton(
                icon: Icon(Icons.edit_outlined, color: palette.primary),
                tooltip: 'Editar datos autorizados',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => StudentEditPage(
                        studentId: student.id,
                        initialName: student.fullName,
                        initialCareer: student.career,
                        initialFaculty: student.faculty ?? '',
                        initialDocument: student.documentNumber ?? '',
                      ),
                    ),
                  );
                },
              ),
          ],
          bottom: TabBar(
            labelColor: palette.primary,
            unselectedLabelColor: palette.textSecondary,
            indicatorColor: palette.primary,
            tabs: const [
              Tab(text: 'Personal'),
              Tab(text: 'Academico'),
              Tab(text: 'Seguimiento'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildProfileSummaryHeader(palette),
            Divider(height: 1, color: palette.border),
            Expanded(
              child: TabBarView(
                children: [
                  StudentPersonalTab(student: student),
                  StudentAcademicTab(student: student),
                  StudentFollowUpTab(student: student),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSummaryHeader(NexIdPalette palette) {
    final bool isRegular = student.status.toLowerCase().contains('regular');
    return Container(
      color: palette.surface,
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarPlaceholder(name: student.fullName, size: 60),
              const SizedBox(width: AppDimensions.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.fullName,
                      style: AppTypography.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${student.code} · ${student.career}',
                      style: AppTypography.bodySmall.copyWith(
                        color: palette.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 6.0,
                      children: [
                        StatusBadge(
                          label: student.status,
                          type: isRegular
                              ? BadgeType.confirmed
                              : BadgeType.pending,
                        ),
                        if (student.isDemoExtendedData)
                          const StatusBadge(
                            label: 'Secciones Academicas Demo',
                            type: BadgeType.info,
                            maxWidth: 190,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
