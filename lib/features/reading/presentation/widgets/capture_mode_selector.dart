import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/credential_models.dart';

/// Selector accesible entre modalidades NFC y QR.
class CaptureModeSelector extends StatelessWidget {
  const CaptureModeSelector({
    super.key,
    required this.selectedMedium,
    required this.onMediumSelected,
  });

  final ReadingMedium selectedMedium;
  final ValueChanged<ReadingMedium> onMediumSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: _buildOption(
              medium: ReadingMedium.nfc,
              label: 'NFC Completo',
              icon: Icons.nfc_outlined,
            ),
          ),
          const SizedBox(width: 4.0),
          Expanded(
            child: _buildOption(
              medium: ReadingMedium.qr,
              label: 'QR Parcial',
              icon: Icons.qr_code_scanner_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required ReadingMedium medium,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = selectedMedium == medium;
    return SizedBox(
      height: AppDimensions.minTouchTarget,
      child: Material(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radius - 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radius - 2),
          onTap: () => onMediumSelected(medium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.background : AppColors.textPrimary,
              ),
              const SizedBox(width: AppDimensions.spaceSmall),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.buttonText.copyWith(
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.background
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
