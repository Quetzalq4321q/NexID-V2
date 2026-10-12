import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/platform/hardware_bridge.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../domain/credential_models.dart';
import '../controllers/reading_controller.dart';

/// Tarjeta central de estado de hardware, permisos en tiempo de ejecucion y captura.
class ScannerStatusCard extends StatelessWidget {
  const ScannerStatusCard({
    super.key,
    required this.controller,
    required this.activePlaceId,
  });

  final ReadingController controller;
  final String activePlaceId;

  @override
  Widget build(BuildContext context) {
    final NexIdPalette palette = NexIdPalette.of(context);
    final bool isNfc = controller.selectedMedium == ReadingMedium.nfc;
    final bool isListening = controller.captureState == CaptureState.listening;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(AppDimensions.spaceLarge),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(
          color: isListening ? palette.primary : palette.border,
          width: isListening ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildHardwareBadge(isNfc),
          const SizedBox(height: AppDimensions.spaceMedium),
          _buildScannerIcon(isNfc, isListening, palette),
          const SizedBox(height: AppDimensions.spaceMedium),
          Text(
            _buildTitleText(isNfc, isListening),
            textAlign: TextAlign.center,
            style: AppTypography.titleMedium.copyWith(
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          Text(
            isNfc
                ? 'Lectura por proximidad (NDEF / IsoDep / Mifare). El hardware NFC consulta la ficha completa autorizada.'
                : 'Lectura optica con permiso de camara. El sistema proyecta unicamente los campos permitidos.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: palette.textSecondary,
            ),
          ),
          if (isNfc && controller.lastDetectedUid != null) ...[
            const SizedBox(height: AppDimensions.spaceSmall),
            _buildLastTagMetadata(palette),
          ],
          if (controller.errorMessage != null) ...[
            const SizedBox(height: AppDimensions.spaceMedium),
            _buildErrorAndPermissionBanner(isNfc, palette),
          ],
          const SizedBox(height: AppDimensions.spaceLarge),
          _buildActionControl(isNfc, isListening, palette),
        ],
      ),
    );
  }

  Widget _buildHardwareBadge(bool isNfc) {
    if (isNfc) {
      final BadgeType type = switch (controller.nfcStatus) {
        NfcHardwareStatus.enabled => BadgeType.confirmed,
        NfcHardwareStatus.disabled => BadgeType.pending,
        NfcHardwareStatus.notSupported => BadgeType.review,
      };
      return StatusBadge(
        label: controller.nfcStatus.label,
        type: type,
        maxWidth: 200,
      );
    } else {
      final BadgeType type = switch (controller.cameraPermission) {
        CameraPermissionStatus.granted => BadgeType.confirmed,
        CameraPermissionStatus.denied => BadgeType.pending,
        CameraPermissionStatus.permanentlyDenied => BadgeType.review,
      };
      return StatusBadge(
        label: 'Camara: ${controller.cameraPermission.label}',
        type: type,
        maxWidth: 220,
      );
    }
  }

  Widget _buildScannerIcon(bool isNfc, bool isListening, NexIdPalette palette) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: isListening ? palette.primary : palette.surfaceAccent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isNfc ? Icons.nfc : Icons.qr_code_scanner,
        size: 36,
        color: isListening ? palette.onPrimary : palette.textPrimary,
      ),
    );
  }

  String _buildTitleText(bool isNfc, bool isListening) {
    if (isNfc) {
      return isListening
          ? 'Acerque la tarjeta NFC al reverso'
          : 'Lector NFC listo';
    }
    return isListening
        ? 'Escaneando codigo QR en vivo...'
        : 'Camara lista para escanear QR';
  }

  Widget _buildLastTagMetadata(NexIdPalette palette) {
    final String techs = controller.lastDetectedTechs.isEmpty
        ? 'Tag NFC'
        : controller.lastDetectedTechs.join(', ');
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceSubtle,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: palette.border),
      ),
      child: Text(
        'Ultimo UID: ${controller.lastDetectedUid} ($techs)',
        style: AppTypography.caption.copyWith(color: palette.textSecondary),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildErrorAndPermissionBanner(bool isNfc, NexIdPalette palette) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMedium),
      decoration: BoxDecoration(
        color: palette.errorSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.error),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            controller.errorMessage!,
            style: AppTypography.bodySmall.copyWith(color: palette.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceSmall),
          if (isNfc && controller.nfcStatus == NfcHardwareStatus.disabled)
            SecondaryButton(
              label: 'Abrir Ajustes NFC de Android',
              icon: Icons.settings_outlined,
              isOutlined: true,
              onPressed: () => controller.openSystemNfcSettings(),
            )
          else if (!isNfc &&
              controller.cameraPermission == CameraPermissionStatus.denied)
            SecondaryButton(
              label: 'Conceder Permiso de Camara',
              icon: Icons.camera_alt_outlined,
              isOutlined: true,
              onPressed: () => controller.requestCameraPermissionExplicit(),
            )
          else if (!isNfc &&
              controller.cameraPermission ==
                  CameraPermissionStatus.permanentlyDenied)
            SecondaryButton(
              label: 'Habilitar Camara en Ajustes',
              icon: Icons.settings_outlined,
              isOutlined: true,
              onPressed: () => controller.openSystemAppSettings(),
            ),
        ],
      ),
    );
  }

  Widget _buildActionControl(
    bool isNfc,
    bool isListening,
    NexIdPalette palette,
  ) {
    if (controller.captureState == CaptureState.resolving) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(palette.primary),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            label: isListening
                ? 'Detener Captura'
                : (isNfc ? 'Activar Captura' : 'Escanear QR con Camara'),
            icon: isListening
                ? Icons.stop
                : (isNfc ? Icons.nfc : Icons.camera_alt_outlined),
            onPressed: () {
              if (isListening) {
                controller.stopListening();
              } else {
                controller.startListening(placeId: activePlaceId);
              }
            },
          ),
        ),
      ],
    );
  }
}
