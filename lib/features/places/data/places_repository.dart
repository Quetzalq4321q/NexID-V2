import '../domain/place_model.dart';

/// Repositorio local de lugares autorizados para el operador.
class PlacesRepository {
  final List<Place> _places = const [
    Place(
      id: 'PL-01',
      code: 'PTA-PRIN',
      name: 'Puerta Principal - Acceso Central',
      description: 'Control de ingreso vehicular y peatonal',
    ),
    Place(
      id: 'PL-02',
      code: 'BIBLIO',
      name: 'Biblioteca Central',
      description: 'Control de sala de lectura y prestamos',
    ),
    Place(
      id: 'PL-03',
      code: 'LAB-COMP',
      name: 'Laboratorio de Computo 1',
      description: 'Acceso especializado para estudiantes de ingenieria',
    ),
    Place(
      id: 'PL-04',
      code: 'COMEDOR',
      name: 'Comedor Universitario',
      description: 'Registro de racion y control de turno',
    ),
  ];

  Future<List<Place>> getAuthorizedPlaces() async {
    return _places;
  }
}
