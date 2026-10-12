import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/student_models.dart';
import 'student_field_card.dart';

/// Pestaña 1: Datos personales, contacto, documentos asociados y fechas importantes.
class StudentPersonalTab extends StatelessWidget {
  const StudentPersonalTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      children: [
        _buildSectionTitle('Datos Personales y de Contacto', palette),
        StudentFieldCard(
          label: 'Documento de Identidad',
          value: student.documentNumber ?? 'No registrado',
        ),
        StudentFieldCard(
          label: 'Correo Institucional',
          value: student.institutionalEmail,
        ),
        StudentFieldCard(
          label: 'Telefono de Contacto',
          value: student.phone,
        ),
        StudentFieldCard(
          label: 'Direccion Registrada',
          value: student.address,
        ),
        StudentFieldCard(
          label: 'Contacto de Emergencia',
          value: student.emergencyContact,
        ),
        const SizedBox(height: AppDimensions.spaceMedium),
        _buildSectionTitle('Documentos Asociados (Demo)', palette),
        ...student.documents.map((StudentRecordNote d) => _buildNoteCard(d, palette)),
        if (student.importantDates.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.spaceMedium),
          _buildSectionTitle('Fechas Importantes', palette),
          ...student.importantDates
              .map((StudentRecordNote d) => _buildNoteCard(d, palette)),
        ],
      ],
    );
  }
}

/// Pestaña 2: Informacion academica, cursos, calificaciones e historial de matriculas.
class StudentAcademicTab extends StatelessWidget {
  const StudentAcademicTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      children: [
        _buildSectionTitle('Resumen Academico Activo', palette),
        StudentFieldCard(label: 'Facultad', value: student.faculty ?? 'General'),
        StudentFieldCard(label: 'Carrera Profesional', value: student.career),
        StudentFieldCard(
          label: 'Periodo y Ciclo',
          value: '${student.academicPeriod} · ${student.academicCycle}',
        ),
        StudentFieldCard(label: 'Seccion y Turno', value: student.section),
        StudentFieldCard(
          label: 'Promedio Ponderado (Demo)',
          value: student.weightedAverage.toStringAsFixed(1),
        ),
        const SizedBox(height: AppDimensions.spaceMedium),
        _buildSectionTitle('Cursos, Grados y Calificaciones (Demo)', palette),
        ...student.courses.map((StudentCourseItem course) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
            padding: const EdgeInsets.all(AppDimensions.spaceMedium),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radius),
              border: Border.all(color: palette.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${course.code} · ${course.name}',
                        style: AppTypography.bodySmall.copyWith(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Seccion ${course.section} · ${course.credits} cred. · Asistencia ${course.attendancePercentage}%',
                        style: AppTypography.caption.copyWith(
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(
                  label: 'Nota: ${course.grade.toStringAsFixed(1)}',
                  type: BadgeType.confirmed,
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: AppDimensions.spaceMedium),
        _buildSectionTitle('Historial de Inscripciones y Matricula', palette),
        ...student.enrollmentHistory.map((EnrollmentHistoryItem item) {
          return StudentFieldCard(
            label: '${item.period} (${item.cycleLabel})',
            value: '${item.condition} · ${item.enrolledCredits} cred.',
          );
        }),
      ],
    );
  }
}

/// Pestaña 3: Historial de asistencia, observaciones y auditoria de modificaciones.
class StudentFollowUpTab extends StatelessWidget {
  const StudentFollowUpTab({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      children: [
        _buildSectionTitle('Indicador de Asistencia del Periodo', palette),
        Container(
          padding: const EdgeInsets.all(AppDimensions.spaceMedium),
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cumplimiento de Asistencia Registrada',
                    style: AppTypography.bodySmall.copyWith(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${student.attendanceRate}%',
                    style: AppTypography.titleMedium.copyWith(
                      color: palette.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: student.attendanceRate / 100.0,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
                color: palette.primary,
                backgroundColor: palette.surfaceSubtle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMedium),
        _buildSectionTitle('Observaciones y Seguimiento', palette),
        ...student.observations
            .map((StudentRecordNote obs) => _buildNoteCard(obs, palette)),
        const SizedBox(height: AppDimensions.spaceMedium),
        _buildSectionTitle('Actividad Reciente e Historial de Cambios', palette),
        ...student.modificationHistory
            .map((StudentRecordNote mod) => _buildNoteCard(mod, palette)),
      ],
    );
  }
}

Widget _buildSectionTitle(String text, NexIdPalette palette) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
    child: Text(
      text,
      style: AppTypography.caption.copyWith(color: palette.textSecondary, fontWeight: FontWeight.w700),
    ),
  );
}

Widget _buildNoteCard(StudentRecordNote note, NexIdPalette palette) {
  return Container(
    margin: const EdgeInsets.only(bottom: AppDimensions.spaceSmall),
    padding: const EdgeInsets.all(AppDimensions.spaceMedium),
    decoration: BoxDecoration(
      color: palette.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radius),
      border: Border.all(color: palette.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                note.title,
                style: AppTypography.bodySmall.copyWith(color: palette.textPrimary, fontWeight: FontWeight.w700),
              ),
            ),
            Text(note.dateLabel, style: AppTypography.caption.copyWith(color: palette.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text('${note.category} · ${note.detail}', style: AppTypography.caption.copyWith(color: palette.textSecondary)),
      ],
    ),
  );
}
