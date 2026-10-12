import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../domain/report_models.dart';
import '../controllers/reports_controller.dart';
import '../widgets/report_job_card.dart';

/// Pantalla 6: Generacion asincrona y descarga de reportes.
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.reportsController,
      builder: (BuildContext context, _) {
        final List<ReportJob> jobs = widget.reportsController.jobs;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spaceLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Formulario de solicitud de reporte
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radius),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Solicitar Nuevo Reporte',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: AppDimensions.spaceMedium),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Titulo del reporte',
                              labelStyle: AppTypography.bodySmall,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimensions.radius),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spaceMedium),
                          Wrap(
                            spacing: AppDimensions.spaceSmall,
                            runSpacing: AppDimensions.spaceSmall,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Formato:',
                                style: AppTypography.bodySmall,
                              ),
                              ChoiceChip(
                                label: const Text('PDF'),
                                selected: _selectedFormat == 'PDF',
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _selectedFormat == 'PDF'
                                      ? AppColors.background
                                      : AppColors.textPrimary,
                                ),
                                onSelected: (_) =>
                                    setState(() => _selectedFormat = 'PDF'),
                              ),
                              ChoiceChip(
                                label: const Text('CSV'),
                                selected: _selectedFormat == 'CSV',
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _selectedFormat == 'CSV'
                                      ? AppColors.background
                                      : AppColors.textPrimary,
                                ),
                                onSelected: (_) =>
                                    setState(() => _selectedFormat = 'CSV'),
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
                    ),
                    const SizedBox(height: AppDimensions.spaceExtraLarge),

                    // Historial de jobs
                    const Text(
                      'Historial de Trabajos Solicitados',
                      style: AppTypography.titleMedium,
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
}
