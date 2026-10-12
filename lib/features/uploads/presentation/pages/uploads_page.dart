import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/upload_models.dart';
import '../controllers/uploads_controller.dart';
import '../widgets/upload_item_card.dart';

/// Pantalla de validacion y subida controlada de archivos segun agent/16_ARCHIVOS.md.
class UploadsPage extends StatelessWidget {
  const UploadsPage({
    super.key,
    required this.controller,
  });

  final UploadsController controller;

  void _onSimulateFilePick(BuildContext context, bool shouldFailSize) {
    if (shouldFailSize) {
      // Simula archivo pesado > 2 MB para validar UX de rechazo
      controller.simulateFileUpload(
        fileName: 'foto_estudiante_pesada.jpg',
        fileSizeBytes: 3 * 1024 * 1024,
        purpose: 'Foto de perfil (Rechazada por tamaño)',
      );
    } else {
      // Simula archivo valido < 2 MB
      controller.simulateFileUpload(
        fileName: 'perfil_estudiante_optimizada.png',
        fileSizeBytes: 850 * 1024,
        purpose: 'Foto de perfil oficial',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, _) {
        final List<UploadFileItem> items = controller.items;

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
                    // Panel de seleccion y politicas
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
                            'Subida Segura de Archivos',
                            style: AppTypography.titleMedium,
                          ),
                          const SizedBox(height: AppDimensions.spaceSmall),
                          const Text(
                            'Politica del servidor: Solo archivos de proposito "foto_perfil". Formatos admitidos: JPG, PNG, WebP. Peso maximo: 2 MB.',
                            style: AppTypography.bodySmall,
                          ),
                          const SizedBox(height: AppDimensions.spaceLarge),
                          LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              final bool isNarrow =
                                  constraints.maxWidth < 460.0;
                              if (isNarrow) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    PrimaryButton(
                                      label: 'Seleccionar Foto',
                                      icon: Icons.add_photo_alternate_outlined,
                                      onPressed: () =>
                                          _onSimulateFilePick(context, false),
                                    ),
                                    const SizedBox(
                                        height: AppDimensions.spaceSmall),
                                    OutlinedButton(
                                      onPressed: () =>
                                          _onSimulateFilePick(context, true),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          0,
                                          AppDimensions.minTouchTarget,
                                        ),
                                      ),
                                      child: const Text(
                                        'Probar Archivo Excedido',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      label: 'Seleccionar Foto',
                                      icon: Icons.add_photo_alternate_outlined,
                                      onPressed: () =>
                                          _onSimulateFilePick(context, false),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: AppDimensions.spaceMedium),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () =>
                                          _onSimulateFilePick(context, true),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radius,
                                          ),
                                        ),
                                        minimumSize: const Size(
                                          0,
                                          AppDimensions.minTouchTarget,
                                        ),
                                      ),
                                      child: const Text(
                                        'Probar Archivo Excedido',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceExtraLarge),

                    const Text(
                      'Historial de Subidas',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceMedium),

                    if (items.isEmpty)
                      const EmptyState(
                        message: 'No hay subidas realizadas en esta sesion.',
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppDimensions.spaceSmall),
                        itemBuilder: (BuildContext context, int index) {
                          return UploadItemCard(item: items[index]);
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
