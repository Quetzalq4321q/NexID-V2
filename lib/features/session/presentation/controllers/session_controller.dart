import 'package:flutter/foundation.dart';
import '../../data/session_repository.dart';
import '../../domain/session_models.dart';

/// Controlador de sesion basado en ChangeNotifier del SDK (agent/02_ARQUITECTURA.md).
class SessionController extends ChangeNotifier {
  SessionController({required this._repository}) {
    _state = _repository.getCurrentSession();
  }

  final SessionRepository _repository;
  late SessionState _state;
  bool _isLoading = false;
  bool _diagnosticElevated = false;

  SessionState get state => _state;
  bool get isAuthenticated => _state.isAuthenticated;
  OperatorUser? get currentUser => _state.user;
  bool get isLoading => _isLoading;
  List<OperatorUser> get availableOperators => _repository.availableOperators;

  /// Determina si la sesion actual cuenta con permisos reales para acceder
  /// a Configuracion avanzada (rol Administrador o autorizacion de diagnostico).
  bool get canAccessAdvancedSettings =>
      (currentUser?.canAccessAdvancedSettings ?? false) || _diagnosticElevated;

  bool authorizeDiagnosticSession(String adminUsername) {
    final String normalized = adminUsername.trim().toLowerCase();
    final bool isValidAdmin = _repository.availableOperators.any(
      (OperatorUser op) =>
          op.role == UserRole.administrador &&
          op.username.toLowerCase() == normalized,
    );
    if (isValidAdmin && !_diagnosticElevated) {
      _diagnosticElevated = true;
      notifyListeners();
    }
    return isValidAdmin;
  }

  void revokeDiagnosticSession() {
    if (!_diagnosticElevated) return;
    _diagnosticElevated = false;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    _state = await _repository.login(username, password);
    _diagnosticElevated = false;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectOperator(OperatorUser operator) async {
    await login(operator.username, 'demo');
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    _state = await _repository.logout();
    _diagnosticElevated = false;

    _isLoading = false;
    notifyListeners();
  }
}
