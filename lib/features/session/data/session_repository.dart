import '../domain/session_models.dart';

/// Repositorio local de sesion sin backend, para funcionamiento offline y local.
class SessionRepository {
  final List<OperatorUser> _availableOperators = const [
    OperatorUser(
      id: 'OP-001',
      username: 'operador.puerta1',
      displayName: 'Carlos Vega',
      role: UserRole.operador,
    ),
    OperatorUser(
      id: 'OP-002',
      username: 'admin.general',
      displayName: 'Dra. Elena Ruiz',
      role: UserRole.administrador,
    ),
    OperatorUser(
      id: 'OP-003',
      username: 'lector.consulta',
      displayName: 'Guardia Turno Tarde',
      role: UserRole.lector,
    ),
  ];

  SessionState _currentState = SessionState.unauthenticated();

  List<OperatorUser> get availableOperators => _availableOperators;

  SessionState getCurrentSession() => _currentState;

  Future<SessionState> login(String username, String password) async {
    // Simulacion local sin servidor
    final OperatorUser user = _availableOperators.firstWhere(
      (u) => u.username == username,
      orElse: () => _availableOperators.first,
    );
    _currentState = SessionState.authenticated(
      user,
      'token-local-simulado-${user.id}',
    );
    return _currentState;
  }

  Future<SessionState> logout() async {
    _currentState = SessionState.unauthenticated();
    return _currentState;
  }
}
