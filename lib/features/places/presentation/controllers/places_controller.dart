import 'package:flutter/foundation.dart';
import '../../data/places_repository.dart';
import '../../domain/place_model.dart';

/// Coordinador de lugar activo para el operador segun agent/17_MODULOS_FLUJOS.md.
class PlacesController extends ChangeNotifier {
  PlacesController({required PlacesRepository repository})
      : _repository = repository {
    _loadPlaces();
  }

  final PlacesRepository _repository;
  List<Place> _places = [];
  Place? _selectedPlace;
  bool _isLoading = false;

  List<Place> get places => _places;
  Place? get selectedPlace => _selectedPlace;
  bool get isLoading => _isLoading;

  Future<void> _loadPlaces() async {
    _isLoading = true;
    notifyListeners();

    _places = await _repository.getAuthorizedPlaces();
    if (_places.isNotEmpty && _selectedPlace == null) {
      _selectedPlace = _places.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectPlace(Place? place) {
    if (place != null && place != _selectedPlace) {
      _selectedPlace = place;
      notifyListeners();
    }
  }
}
