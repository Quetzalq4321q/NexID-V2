import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
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
    final NexIdPalette palette = NexIdPalette.of(context);
    final Place? currentPlace = controller.selectedPlace;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMedium,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        border: Border.all(color: palette.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Place>(
          value: currentPlace,
          isExpanded: true,
          dropdownColor: palette.surfaceElevated,
          icon: Icon(Icons.arrow_drop_down, color: palette.textPrimary),
          items: controller.places.map((Place place) {
            return DropdownMenuItem<Place>(
              value: place,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: palette.primary,
                  ),
                  const SizedBox(width: AppDimensions.spaceSmall),
                  Expanded(
                    child: Text(
                      place.name,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
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
