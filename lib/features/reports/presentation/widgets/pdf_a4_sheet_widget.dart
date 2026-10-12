import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../records/domain/record_models.dart';
import '../../../students/domain/student_models.dart';
import 'pdf_a4_sections_widget.dart';

/// Tipo de plantilla de documento A4 para vista previa de impresion.
enum PdfTemplateType {
  studentFicha('Ficha Institucional de Alumno'),
  recordsReport('Reporte General de Registros');

  const PdfTemplateType(this.label);
  final String label;
}

/// Lienzo con formato A4 (210x297mm) listo para impresion institucional.
/// Mantiene superficie de papel blanco (#FFFFFF) y tinta oscura (#180F24)
/// para representar fielmente la hoja impresa en cualquier tema.
class PdfA4SheetWidget extends StatelessWidget {
  const PdfA4SheetWidget({
    super.key,
    required this.templateType,
    required this.student,
    required this.records,
    required this.issuedAt,
  });

  final PdfTemplateType templateType;
  final Student student;
  final List<EventRecord> records;
  final DateTime issuedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 620),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInstitutionalHeader(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, thickness: 1.5, color: AppColors.primary),
          ),
          _buildDocumentTitleBar(),
          const SizedBox(height: 14),
          if (templateType == PdfTemplateType.studentFicha)
            PdfStudentSectionContent(student: student)
          else
            PdfRecordsSectionContent(records: records),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),
          _buildInstitutionalFooter(),
        ],
      ),
    );
  }

  Widget _buildInstitutionalHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: const Icon(Icons.nfc, color: AppColors.background, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DIRECCION DE REGISTRO Y CONTROL ACADEMICO - NEXID',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Sistema Institucional de Identificacion NFC / QR',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'FORMATO A4 (210x297mm)',
                textAlign: TextAlign.right,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
              Text(
                'Emision: ${DateFormatter.formatDateTime(issuedAt)}',
                textAlign: TextAlign.right,
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentTitleBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              templateType == PdfTemplateType.studentFicha
                  ? 'FICHA OFICIAL DE EXPEDIENTE Y ASISTENCIA DE ALUMNO'
                  : 'REPORTE CONSOLIDADO DE EVENTOS Y AUDITORIA DE ACCESO',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            'Folio: NEX-2026-0412',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionalFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Documento generado localmente por NexID Terminal · Uso exclusivo autorizado',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ),
        Text(
          'Pagina 1 de 1',
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
