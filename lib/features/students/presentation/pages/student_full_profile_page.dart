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

/// Expediente integral del alumno que hidrata bajo demanda los datos
/// secundarios (cursos, documentos y seguimiento) al abrir la ficha.
class StudentFullProfilePage extends StatefulWidget {
  const StudentFullProfilePage({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<StudentFullProfilePage> createState() => _StudentFullProfilePageState();
}

class _StudentFullProfilePageState extends State<StudentFullProfilePage> {
  late Student _hydratedStudent;
  bool _didRequestHydration = false;

  @override
  void initState() {
    super.initState();
    _hydratedStudent = widget.student;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didRequestHydration) {
      _didRequestHydration = true;
      _hydrateSecondaryData();
    }
  }

  Future<void> _hydrateSecondaryData() async {
    final AppDependencies deps = AppDependencies.of(context);
    final Student full = await deps.studentsController
        .hydrateStudentForProfile(widget.student);
    if (mounted) {
      setState(() => _hydratedStudent = full);
    }
  }

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
                      initialStudent: _hydratedStudent,
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
                        studentId: _hydratedStudent.id,
                        initialName: _hydratedStudent.fullName,
                        initialCareer: _hydratedStudent.career,
                        initialFaculty: _hydratedStudent.faculty ?? '',
                        initialDocument: _hydratedStudent.documentNumber ?? '',
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
                  StudentPersonalTab(student: _hydratedStudent),
                  StudentAcademicTab(student: _hydratedStudent),
                  StudentFollowUpTab(student: _hydratedStudent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSummaryHeader(NexIdPalette palette) {
    final bool isRegular =
        _hydratedStudent.status.toLowerCase().contains('regular');
    return Container(
      color: palette.surface,
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarPlaceholder(name: _hydratedStudent.fullName, size: 60),
          const SizedBox(width: AppDimensions.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hydratedStudent.fullName,
                  style: AppTypography.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_hydratedStudent.code} · ${_hydratedStudent.career}',
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
                      label: _hydratedStudent.status,
                      type: isRegular ? BadgeType.confirmed : BadgeType.pending,
                    ),
                    if (_hydratedStudent.isDemoExtendedData)
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
    );
  }
}
