import 'package:flutter/material.dart';
import '../../../../app/app_dependencies.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/avatar_placeholder.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../reading/domain/credential_models.dart';
import '../../../records/domain/record_models.dart';
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
    await dependencies.recordsController.createRecord(
      studentId: widget.credential.studentId,
      studentCode: widget.credential.studentCode,
      studentName: widget.credential.studentName,
      placeId: place?.id ?? 'PL-01',
      placeName: place?.name ?? 'Punto de Control',
      eventType: eventType,
      medium: widget.credential.medium,
    );

    // Actualiza estadisticas de la cola de sincronizacion local
    await dependencies.syncController.refreshStats();

    if (!mounted) return;
    setState(() {
      _isRegistering = false;
      _successMessage = 'Evento "${eventType.label}" registrado con exito.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ResolvedCredential cred = widget.credential;
    final dependencies = AppDependencies.of(context);
    final bool canEdit = dependencies.sessionController.currentUser?.canEditStudents ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ficha de Alumno', style: AppTypography.titleMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: widget.onDismiss,
        ),
        actions: [
          if (canEdit)
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              tooltip: 'Editar datos autorizados',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
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
                // Banner de proyeccion (NFC vs QR)
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceMedium),
                  decoration: BoxDecoration(
                    color: cred.isFullProjection
                        ? AppColors.surfaceAccent
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radius),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cred.isFullProjection
                            ? Icons.verified_user_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: AppDimensions.spaceSmall),
                      Expanded(
                        child: Text(
                          cred.isFullProjection
                              ? 'Ficha Completa Autorizada (Lectura NFC)'
                              : 'Proyeccion Parcial Restringida (Lectura QR)',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      StatusBadge(
                        label: cred.visibility.label,
                        type: BadgeType.info,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceLarge),

                // Perfil principal
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
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Codigo: ${cred.studentCode}',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cred.career,
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceLarge),

                // Campos de detalle
                _buildFieldCard('Estado Academico', cred.status),
                if (cred.isFullProjection && cred.faculty != null)
                  _buildFieldCard('Facultad', cred.faculty!),
                if (cred.isFullProjection && cred.documentNumber != null)
                  _buildFieldCard('Documento de Identidad', cred.documentNumber!)
                else if (!cred.isFullProjection)
                  _buildFieldCard(
                    'Documento de Identidad',
                    'Oculto por politica de modalidad QR',
                    isDimmed: true,
                  ),

                _buildFieldCard(
                  'Ultima Resolucion',
                  DateFormatter.formatDateTime(cred.resolvedAt),
                ),

                const SizedBox(height: AppDimensions.spaceLarge),

                // Mensaje de exito
                if (_successMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.spaceMedium),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(25),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radius),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Text(
                      _successMessage!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceLarge),
                ],

                // Acciones operativas de registro
                const Text(
                  'Acciones de Registro',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: AppDimensions.spaceSmall),
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Registrar Ingreso',
                        icon: Icons.login,
                        isLoading: _isRegistering,
                        onPressed: () => _handleRegisterEvent(
                          context,
                          EventType.entrada,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMedium),
                    Expanded(
                      child: SecondaryButton(
                        label: 'Registrar Salida',
                        icon: Icons.logout,
                        onPressed: () => _handleRegisterEvent(
                          context,
                          EventType.salida,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldCard(String label, String value, {bool isDimmed = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: isDimmed
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
