import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../records/domain/record_models.dart';
import '../../../students/domain/student_models.dart';
import '../widgets/pdf_a4_sheet_widget.dart';

/// Vista previa interactiva de documento PDF institucional en formato A4
/// optimizada con RepaintBoundary e hidratacion bajo demanda (Prioridad 0).
class PdfPreviewPage extends StatefulWidget {
  const PdfPreviewPage({
    super.key,
    this.initialTemplate = PdfTemplateType.studentFicha,
    this.initialStudent,
  });

  final PdfTemplateType initialTemplate;
  final Student? initialStudent;

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  late PdfTemplateType _templateType;
  Student? _selectedStudent;
  bool _didHydrateInitial = false;
  final DateTime _issuedAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    _templateType = widget.initialTemplate;
    _selectedStudent = widget.initialStudent;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didHydrateInitial) {
      _didHydrateInitial = true;
      _hydrateSelectedStudentIfNeeded();
    }
  }

  Student _fallbackStudent(List<Student> allStudents) {
    return _selectedStudent ??
        (allStudents.isNotEmpty
            ? allStudents.first
            : Student(
                id: 'STU-1001',
                code: '2023-0149',
                fullName: 'Ana Maria Morales Quispe',
                career: 'Ingenieria de Sistemas',
                status: 'Matriculado Regular',
                updatedAt: _issuedAt,
              ));
  }

  Future<void> _hydrateSelectedStudentIfNeeded() async {
    final AppDependencies deps = AppDependencies.of(context);
    final Student base = _fallbackStudent(deps.studentsController.students);
    if (base.courses.isNotEmpty) {
      _selectedStudent = base;
      return;
    }
    final Student hydrated =
        await deps.studentsController.hydrateStudentForProfile(base);
    if (mounted) {
      setState(() => _selectedStudent = hydrated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final AppDependencies deps = AppDependencies.of(context);
    final List<Student> allStudents = deps.studentsController.students;
    final List<EventRecord> allRecords = deps.recordsController.records;
    final Student activeStudent = _fallbackStudent(allStudents);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(
          'Vista Previa de Documento PDF (A4)',
          style: AppTypography.titleMedium.copyWith(color: palette.textPrimary),
        ),
        backgroundColor: palette.surface,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildControlToolbar(deps, palette, allStudents, activeStudent),
            Divider(height: 1, color: palette.border),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spaceLarge),
                child: Center(
                  child: RepaintBoundary(
                    child: PdfA4SheetWidget(
                      templateType: _templateType,
                      student: activeStudent,
                      records: allRecords,
                      issuedAt: _issuedAt,
                    ),
                  ),
                ),
              ),
            ),
            _buildBottomActionBar(context, palette, deps, activeStudent),
          ],
        ),
      ),
    );
  }

  Widget _buildControlToolbar(
    AppDependencies deps,
    NexIdPalette palette,
    List<Student> allStudents,
    Student activeStudent,
  ) {
    return Container(
      color: palette.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLarge,
        vertical: AppDimensions.spaceSmall,
      ),
      child: Wrap(
        spacing: AppDimensions.spaceSmall,
        runSpacing: AppDimensions.spaceSmall,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'Plantilla A4:',
            style: AppTypography.caption.copyWith(
              color: palette.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          ...PdfTemplateType.values.map((PdfTemplateType type) {
            return ChoiceChip(
              label: Text(type.label),
              selected: _templateType == type,
              onSelected: (_) => setState(() => _templateType = type),
            );
          }),
          if (_templateType == PdfTemplateType.studentFicha &&
              allStudents.length > 1)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: activeStudent.id,
                  isExpanded: true,
                  dropdownColor: palette.surfaceElevated,
                  items: allStudents.map((Student s) {
                    return DropdownMenuItem<String>(
                      value: s.id,
                      child: Text(
                        s.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? id) async {
                    if (id == null) return;
                    final Student found = allStudents.firstWhere(
                      (Student s) => s.id == id,
                      orElse: () => activeStudent,
                    );
                    final Student hydrated = await deps.studentsController
                        .hydrateStudentForProfile(found);
                    if (mounted) {
                      setState(() => _selectedStudent = hydrated);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(
    BuildContext context,
    NexIdPalette palette,
    AppDependencies deps,
    Student activeStudent,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLarge,
        vertical: AppDimensions.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Formato: A4 Vertical · Pagina 1 de 1 · Listo para impresion',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          PrimaryButton(
            label: 'Confirmar y Emitir PDF',
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () {
              final String title = _templateType == PdfTemplateType.studentFicha
                  ? 'Ficha A4 - ${activeStudent.fullName}'
                  : 'Reporte Consolidado A4 de Registros';
              deps.reportsController.requestReport(
                title: title,
                format: 'PDF',
                placeName: deps.placesController.selectedPlace?.name ??
                    'Punto Central',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Documento PDF "$title" encolado y generado.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
