import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../domain/report_models.dart';
import '../controllers/reports_controller.dart';

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
                          Row(
                            children: [
                              const Text(
                                'Formato:',
                                style: AppTypography.bodySmall,
                              ),
                              const SizedBox(width: AppDimensions.spaceMedium),
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
                              const SizedBox(width: AppDimensions.spaceSmall),
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
                            label: 'Generar Reporte en Segundo Plano',
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
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppDimensions.spaceSmall),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildJobCard(jobs[index]);
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

  Widget _buildJobCard(ReportJob job) {
    final BadgeType badgeType = switch (job.status) {
      ReportStatus.queued => BadgeType.pending,
      ReportStatus.processing => BadgeType.info,
      ReportStatus.completed => BadgeType.confirmed,
      ReportStatus.failed => BadgeType.review,
    };

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${job.format} · ${DateFormatter.formatDateTime(job.createdAt)}',
                style: AppTypography.caption,
              ),
              StatusBadge(
                label: job.status.label,
                type: badgeType,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            job.title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Filtro: ${job.filterPlace}',
            style: AppTypography.bodySmall,
          ),
          if (job.status == ReportStatus.completed) ...[
            const SizedBox(height: AppDimensions.spaceMedium),
            SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.download_outlined, size: 16),
                label: const Text('Descargar Archivo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Descargando ${job.title}...'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
