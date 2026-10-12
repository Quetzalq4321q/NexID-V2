import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../domain/report_models.dart';
import '../controllers/reports_controller.dart';
import '../widgets/pdf_a4_sheet_widget.dart';
import '../widgets/report_job_card.dart';
import 'pdf_preview_page.dart';

/// Pantalla 6: Generacion asincrona, vista previa A4 y descarga de reportes.
class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
    required this.reportsController,
    required this.placesController,
  });

  final ReportsController reportsController;
  final PlacesController placesController;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedFormat = 'PDF';
  final TextEditingController _titleController = TextEditingController(
    text: 'Reporte General de Accesos',
  );

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _onRequestJob() {
    final String title = _titleController.text.trim();
    if (title.isEmpty) return;

    final String placeName =
        widget.placesController.selectedPlace?.name ?? 'Todos los Puntos';

    widget.reportsController.requestReport(
      title: title,
      format: _selectedFormat,
      placeName: placeName,
    );
  }

  void _openPdfPreview(BuildContext context, PdfTemplateType template) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PdfPreviewPage(initialTemplate: template),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.reportsController,
      builder: (BuildContext context, _) {
        final NexIdPalette palette = NexIdPalette.of(context);
        final List<ReportJob> jobs = widget.reportsController.jobs;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPreviewSampleCard(context, palette),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildRequestFormCard(palette),
                    const SizedBox(height: AppDimensions.spaceExtraLarge),
                    Text(
                      'Historial de Trabajos Solicitados',
                      style: AppTypography.titleMedium.copyWith(
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceMedium),
                    if (jobs.isEmpty)
                      const EmptyState(
                        message: 'No hay reportes generados recientemente.',
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: jobs.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppDimensions.spaceSmall),
                        itemBuilder: (BuildContext context, int index) {
                          return ReportJobCard(job: jobs[index]);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewSampleCard(BuildContext context, NexIdPalette palette) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      decoration: BoxDecoration(
        color: palette.surfaceAccent,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.picture_as_pdf_outlined, color: palette.primary),
              const SizedBox(width: AppDimensions.spaceSmall),
              Expanded(
                child: Text(
                  'Vista Previa Institucional A4 (PDF)',
                  style: AppTypography.titleMedium.copyWith(
                    color: palette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceXSmall),
          Text(
            'Revise la maqueta de impresion en formato A4 con encabezado institucional, logo, tablas ordenadas, indicadores, fecha y numeracion.',
            style: AppTypography.bodySmall.copyWith(
              color: palette.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Wrap(
            spacing: AppDimensions.spaceSmall,
            runSpacing: AppDimensions.spaceSmall,
            children: [
              SecondaryButton(
                label: 'Ver PDF Ficha de Alumno',
                icon: Icons.badge_outlined,
                isOutlined: true,
                onPressed: () =>
                    _openPdfPreview(context, PdfTemplateType.studentFicha),
              ),
              SecondaryButton(
                label: 'Ver PDF Reporte de Registros',
                icon: Icons.table_chart_outlined,
                isOutlined: true,
                onPressed: () =>
                    _openPdfPreview(context, PdfTemplateType.recordsReport),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestFormCard(NexIdPalette palette) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Solicitar Nuevo Reporte',
            style: AppTypography.titleMedium.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          TextField(
            controller: _titleController,
            style: AppTypography.bodyMedium.copyWith(color: palette.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Titulo del reporte',
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Wrap(
            spacing: AppDimensions.spaceSmall,
            runSpacing: AppDimensions.spaceSmall,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Formato:',
                style: AppTypography.bodySmall.copyWith(
                  color: palette.textSecondary,
                ),
              ),
              ChoiceChip(
                label: const Text('PDF'),
                selected: _selectedFormat == 'PDF',
                onSelected: (_) => setState(() => _selectedFormat = 'PDF'),
              ),
              ChoiceChip(
                label: const Text('CSV'),
                selected: _selectedFormat == 'CSV',
                onSelected: (_) => setState(() => _selectedFormat = 'CSV'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLarge),
          PrimaryButton(
            label: 'Generar Reporte',
            icon: Icons.assignment_outlined,
            onPressed: _onRequestJob,
          ),
        ],
      ),
    );
  }
}
