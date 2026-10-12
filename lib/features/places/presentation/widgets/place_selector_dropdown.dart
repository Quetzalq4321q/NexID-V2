import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../domain/place_model.dart';
import '../controllers/places_controller.dart';

/// Selector desplegable del punto de control activo.
class PlaceSelectorDropdown extends StatelessWidget {
  const PlaceSelectorDropdown({
    super.key,
    required this.controller,
  });

  final PlacesController controller;

  @override
  Widget build(BuildContext context) {
    final Place? currentPlace = controller.selectedPlace;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Place>(
          value: currentPlace,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
          items: controller.places.map((Place place) {
            return DropdownMenuItem<Place>(
              value: place,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.spaceSmall),
                  Expanded(
                    child: Text(
                      place.name,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (Place? place) {
            controller.selectPlace(place);
          },
        ),
      ),
    );
  }
}
