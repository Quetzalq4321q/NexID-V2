import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../../places/presentation/widgets/place_selector_dropdown.dart';
import '../../../students/presentation/pages/student_detail_page.dart';
import '../../domain/credential_models.dart';
import '../controllers/reading_controller.dart';
import '../widgets/capture_mode_selector.dart';

/// Pantalla 2: Lectura y captura de credenciales NFC y QR.
class ReadingPage extends StatefulWidget {
  const ReadingPage({
    super.key,
    required this.readingController,
    required this.placesController,
  });

  final ReadingController readingController;
  final PlacesController placesController;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final TextEditingController _manualTokenController = TextEditingController();

  @override
  void dispose() {
    _manualTokenController.dispose();
    super.dispose();
  }

  void _onScanTriggered(String token) {
    final String placeId =
        widget.placesController.selectedPlace?.id ?? 'PL-01';
    widget.readingController.simulateScan(
      token: token,
      placeId: placeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.readingController,
        widget.placesController,
      ]),
      builder: (BuildContext context, _) {
        final ReadingController controller = widget.readingController;

        // Si ya se resolvio una credencial, mostrar la ficha
        if (controller.captureState == CaptureState.resolved &&
            controller.lastResult != null) {
          return StudentDetailPage(
            credential: controller.lastResult!,
            onDismiss: () => controller.resetCapture(),
          );
        }

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
                    // Lugar activo
                    const Text(
                      'Punto de control operativo',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppDimensions.spaceSmall),
                    PlaceSelectorDropdown(
                      controller: widget.placesController,
                    ),
                    const SizedBox(height: AppDimensions.spaceLarge),

                    // Selector de modalidad
                    CaptureModeSelector(
                      selectedMedium: controller.selectedMedium,
                      onMediumSelected: controller.selectMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceLarge),

                    // Area central de escaneo segun modalidad
                    _buildScannerArea(controller),
                    const SizedBox(height: AppDimensions.spaceLarge),

                    // Fichas rapidas para pruebas locales
                    _buildTestTokensSection(controller),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScannerArea(ReadingController controller) {
    final bool isNfc = controller.selectedMedium == ReadingMedium.nfc;
    final bool isListening = controller.captureState == CaptureState.listening;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: isListening ? AppColors.primary : AppColors.border,
          width: isListening ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isListening
                  ? AppColors.primary
                  : AppColors.surfaceAccent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isNfc ? Icons.nfc : Icons.camera_alt_outlined,
              size: 36,
              color: isListening
                  ? AppColors.background
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMedium),
          Text(
            isNfc
                ? (isListening
                    ? 'Acerque la tarjeta NFC al dispositivo'
                    : 'Lector NFC listo')
                : (isListening
                    ? 'Escaneando codigo QR en vivo...'
                    : 'Camara lista para escanear QR'),
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            isNfc
                ? 'Lectura por proximidad. El hardware NFC consultara la ficha completa autorizada.'
                : 'Lectura optica. El servidor proyectara unicamente los campos permitidos.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppDimensions.spaceLarge),
          if (controller.captureState == CaptureState.resolving)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: isListening ? 'Detener Captura' : 'Activar Captura',
                    icon: isListening ? Icons.stop : Icons.play_arrow,
                    onPressed: () {
                      if (isListening) {
                        controller.stopListening();
                      } else {
                        controller.startListening();
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTestTokensSection(ReadingController controller) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Credenciales de prueba local',
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Wrap(
            spacing: AppDimensions.spaceSmall,
            runSpacing: AppDimensions.spaceSmall,
            children: controller.testTokens.map((String token) {
              return SecondaryButton(
                label: token,
                isOutlined: true,
                onPressed: () => _onScanTriggered(token),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
