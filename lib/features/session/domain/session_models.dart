/// Roles autorizados segun el alcance de la aplicacion.
enum UserRole {
  operador('Operador'),
  administrador('Administrador'),
  lector('Solo Lectura');

  const UserRole(this.label);
  final String label;
}

/// Usuario operador autenticado en el sistema.
class OperatorUser {
  const OperatorUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
  });

  final String id;
  final String username;
  final String displayName;
  final UserRole role;

  bool get canEditStudents => role == UserRole.administrador;
  bool get canUploadPhotos => role == UserRole.administrador || role == UserRole.operador;
  bool get canRegisterEvents => role != UserRole.lector;
}

/// Estado inmutable de la sesion.
class SessionState {
  const SessionState({
    required this.isAuthenticated,
    this.user,
    this.token,
  });

  final bool isAuthenticated;
  final OperatorUser? user;
  final String? token;

  factory SessionState.unauthenticated() => const SessionState(
        isAuthenticated: false,
      );

  factory SessionState.authenticated(OperatorUser user, String token) =>
      SessionState(
        isAuthenticated: true,
        user: user,
        token: token,
      );
}
