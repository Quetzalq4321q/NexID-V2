import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../../places/presentation/widgets/place_selector_dropdown.dart';
import '../../../students/presentation/pages/student_detail_page.dart';
import '../controllers/reading_controller.dart';
import '../widgets/capture_mode_selector.dart';
import '../widgets/scanner_status_card.dart';

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
        final NexIdPalette palette = NexIdPalette.of(context);
        final ReadingController controller = widget.readingController;
        final String placeId =
            widget.placesController.selectedPlace?.id ?? 'PL-01';

        if (controller.captureState == CaptureState.resolved &&
            controller.lastResult != null) {
          return StudentDetailPage(
            credential: controller.lastResult!,
            onDismiss: () => controller.resetCapture(),
          );
        }

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
                    Text(
                      'Punto de control operativo',
                      style: AppTypography.caption.copyWith(
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceSmall),
                    PlaceSelectorDropdown(
                      controller: widget.placesController,
                    ),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    CaptureModeSelector(
                      selectedMedium: controller.selectedMedium,
                      onMediumSelected: controller.selectMedium,
                    ),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    ScannerStatusCard(
                      controller: controller,
                      activePlaceId: placeId,
                    ),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildTestTokensSection(controller, palette),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestTokensSection(
    ReadingController controller,
    NexIdPalette palette,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credenciales de prueba local',
            style: AppTypography.caption.copyWith(
              color: palette.textSecondary,
            ),
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
