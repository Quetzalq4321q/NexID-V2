import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/student_models.dart';

/// Pantalla 5: Edicion de datos autorizados de un alumno.
class StudentEditPage extends StatefulWidget {
  const StudentEditPage({
    super.key,
    required this.studentId,
    required this.initialName,
    required this.initialCareer,
    required this.initialFaculty,
    required this.initialDocument,
  });

  final String studentId;
  final String initialName;
  final String initialCareer;
  final String initialFaculty;
  final String initialDocument;

  @override
  State<StudentEditPage> createState() => _StudentEditPageState();
}

class _StudentEditPageState extends State<StudentEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _careerController;
  late final TextEditingController _facultyController;
  late final TextEditingController _documentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _careerController = TextEditingController(text: widget.initialCareer);
    _facultyController = TextEditingController(text: widget.initialFaculty);
    _documentController = TextEditingController(text: widget.initialDocument);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _careerController.dispose();
    _facultyController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final dependencies = AppDependencies.of(context);

    final Student updated = Student(
      id: widget.studentId,
      code: 'COD-${widget.studentId}',
      fullName: _nameController.text.trim(),
      career: _careerController.text.trim(),
      faculty: _facultyController.text.trim(),
      documentNumber: _documentController.text.trim(),
      status: 'Actualizado',
      updatedAt: DateTime.now(),
    );

    await dependencies.studentsController.updateStudent(updated);

    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Datos del alumno actualizados en cache local.'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(
          'Editar Alumno',
          style: AppTypography.titleMedium.copyWith(color: palette.textPrimary),
        ),
        backgroundColor: palette.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField('Nombres y Apellidos', _nameController, palette),
                const SizedBox(height: AppDimensions.spaceMedium),
                _buildTextField('Carrera Profesional', _careerController, palette),
                const SizedBox(height: AppDimensions.spaceMedium),
                _buildTextField('Facultad', _facultyController, palette),
                const SizedBox(height: AppDimensions.spaceMedium),
                _buildTextField('Documento de Identidad', _documentController, palette),
                const SizedBox(height: AppDimensions.spaceLarge),
                PrimaryButton(
                  label: 'Guardar Cambios',
                  icon: Icons.save_outlined,
                  isLoading: _isSaving,
                  onPressed: _handleSave,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    NexIdPalette palette,
  ) {
    return TextField(
      controller: controller,
      style: AppTypography.bodyMedium.copyWith(color: palette.textPrimary),
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
