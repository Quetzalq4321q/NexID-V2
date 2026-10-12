import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../records/domain/record_models.dart';
import '../../../students/domain/student_models.dart';

/// Cuerpo de tablas e indicadores A4 para ficha de alumno y reporte de registros.
class PdfStudentSectionContent extends StatelessWidget {
  const PdfStudentSectionContent({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildKeyValueGrid(<(String, String)>[
          ('Alumno', student.fullName),
          ('Codigo / DNI', '${student.code} / ${student.documentNumber ?? "-"}'),
          ('Carrera', student.career),
          ('Facultad', student.faculty ?? 'General'),
          ('Periodo / Ciclo', '${student.academicPeriod} · ${student.academicCycle}'),
          ('Estado Academico', student.status),
        ]),
        const SizedBox(height: 12),
        Row(
          children: [
            PdfA4KpiBox(label: 'Promedio Ponderado', value: '${student.weightedAverage}'),
            const SizedBox(width: 8),
            PdfA4KpiBox(label: 'Asistencia Global', value: '${student.attendanceRate}%'),
            const SizedBox(width: 8),
            PdfA4KpiBox(label: 'Cursos Activos', value: '${student.courses.length}'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'TABLA DE ASIGNATURAS Y RENDIMIENTO (DATOS DEMO)',
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        PdfA4OrderedTable(
          headers: const <String>['Codigo', 'Asignatura', 'Cred.', 'Nota', 'Asist.'],
          rows: student.courses
              .map(
                (StudentCourseItem c) => <String>[
                  c.code,
                  c.name,
                  '${c.credits}',
                  c.grade.toStringAsFixed(1),
                  '${c.attendancePercentage}%',
                ],
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildKeyValueGrid(List<(String, String)> items) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: items.map(((String, String) entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${entry.$1}:',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.$2,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PdfRecordsSectionContent extends StatelessWidget {
  const PdfRecordsSectionContent({super.key, required this.records});

  final List<EventRecord> records;

  @override
  Widget build(BuildContext context) {
    final int confirmed = records
        .where((EventRecord r) => r.syncStatus == RecordSyncStatus.confirmed)
        .length;
    final int pending = records
        .where((EventRecord r) => r.syncStatus == RecordSyncStatus.pending)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            PdfA4KpiBox(label: 'Total Registros', value: '${records.length}'),
            const SizedBox(width: 8),
            PdfA4KpiBox(label: 'Confirmados', value: '$confirmed'),
            const SizedBox(width: 8),
            PdfA4KpiBox(label: 'En Cola Local', value: '$pending'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'REGISTROS DE CONTROL EMITIDOS DESDE TERMINAL LOCAL',
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        PdfA4OrderedTable(
          headers: const <String>['ID', 'Alumno', 'Operacion', 'Punto', 'Estado'],
          rows: records.take(6).map((EventRecord r) {
            return <String>[
              r.id,
              r.studentName,
              '${r.eventType.label} (${r.medium.name.toUpperCase()})',
              r.placeName,
              r.syncStatus.label,
            ];
          }).toList(),
        ),
      ],
    );
  }
}

class PdfA4KpiBox extends StatelessWidget {
  const PdfA4KpiBox({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfA4OrderedTable extends StatelessWidget {
  const PdfA4OrderedTable({super.key, required this.headers, required this.rows});

  final List<String> headers;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: AppColors.border, width: 1),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(2.4),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppColors.surfaceAccent),
          children: headers.map((String h) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                h,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            );
          }).toList(),
        ),
        ...rows.map((List<String> row) {
          return TableRow(
            children: row.map((String cell) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  cell,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
