import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/avatar_placeholder.dart';
import '../../../reading/domain/credential_models.dart';
import '../../../records/domain/record_models.dart';
import '../widgets/projection_badge_banner.dart';
import '../widgets/student_action_buttons.dart';
import '../widgets/student_field_card.dart';
import 'student_edit_page.dart';

/// Pantalla 3: Ficha de alumno con proyeccion autorizada segun agent/13_NFC_QR.md.
class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({
    super.key,
    required this.credential,
    required this.onDismiss,
  });

  final ResolvedCredential credential;
  final VoidCallback onDismiss;

  @override
  State<StudentDetailPage> createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  bool _isRegistering = false;
  String? _successMessage;

  Future<void> _handleRegisterEvent(
    BuildContext context,
    EventType eventType,
  ) async {
    final dependencies = AppDependencies.of(context);
    setState(() => _isRegistering = true);

    final place = dependencies.placesController.selectedPlace;
    final operatorName =
        dependencies.sessionController.currentUser?.displayName ??
            'Operador Local';
    await dependencies.recordsController.createRecord(
      studentId: widget.credential.studentId,
      studentCode: widget.credential.studentCode,
      studentName: widget.credential.studentName,
      placeId: place?.id ?? 'PL-01',
      placeName: place?.name ?? 'Punto de Control',
      eventType: eventType,
      medium: widget.credential.medium,
      operatorName: operatorName,
    );

    await dependencies.syncController.refreshStats();

    if (!mounted) return;
    setState(() {
      _isRegistering = false;
      _successMessage = 'Evento "${eventType.label}" registrado con exito.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final ResolvedCredential cred = widget.credential;
    final dependencies = AppDependencies.of(context);
    final bool canEdit =
        dependencies.sessionController.currentUser?.canEditStudents ?? false;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(
          'Ficha de Alumno',
          style: AppTypography.titleMedium.copyWith(color: palette.textPrimary),
        ),
        backgroundColor: palette.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: palette.textPrimary),
          onPressed: widget.onDismiss,
        ),
        actions: [
          if (canEdit)
            IconButton(
              icon: Icon(Icons.edit_outlined, color: palette.primary),
              tooltip: 'Editar datos autorizados',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StudentEditPage(
                      studentId: cred.studentId,
                      initialName: cred.studentName,
                      initialCareer: cred.career,
                      initialFaculty: cred.faculty ?? '',
                      initialDocument: cred.documentNumber ?? '',
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spaceLarge),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProjectionBadgeBanner(credential: cred),
                const SizedBox(height: AppDimensions.spaceLarge),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AvatarPlaceholder(name: cred.studentName, size: 72),
                    const SizedBox(width: AppDimensions.spaceMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cred.studentName,
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 20,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Codigo: ${cred.studentCode}',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: palette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cred.career,
                            style: AppTypography.bodyMedium.copyWith(
                              color: palette.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLarge),
                StudentFieldCard(label: 'Estado Academico', value: cred.status),
                if (cred.isFullProjection && cred.faculty != null)
                  StudentFieldCard(label: 'Facultad', value: cred.faculty!),
                if (cred.isFullProjection && cred.documentNumber != null)
                  StudentFieldCard(
                    label: 'Documento de Identidad',
                    value: cred.documentNumber!,
                  )
                else if (!cred.isFullProjection)
                  const StudentFieldCard(
                    label: 'Documento de Identidad',
                    value: 'Oculto por politica de modalidad QR',
                    isDimmed: true,
                  ),
                StudentFieldCard(
                  label: 'Ultima Resolucion',
                  value: DateFormatter.formatDateTime(cred.resolvedAt),
                ),
                const SizedBox(height: AppDimensions.spaceLarge),
                if (_successMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceMedium),
                    decoration: BoxDecoration(
                      color: palette.successSurface,
                      borderRadius: BorderRadius.circular(AppDimensions.radius),
                      border: Border.all(color: palette.success),
                    ),
                    child: Text(
                      _successMessage!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: palette.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLarge),
                ],
                Text(
                  'Acciones de Registro',
                  style: AppTypography.caption.copyWith(
                    color: palette.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceSmall),
                StudentActionButtons(
                  isRegistering: _isRegistering,
                  onRegister: (EventType type) =>
                      _handleRegisterEvent(context, type),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
