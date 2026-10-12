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

  SessionState get state => _state;
  bool get isAuthenticated => _state.isAuthenticated;
  OperatorUser? get currentUser => _state.user;
  bool get isLoading => _isLoading;
  List<OperatorUser> get availableOperators => _repository.availableOperators;

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 300));
    _state = await _repository.login(username, password);

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

    _isLoading = false;
    notifyListeners();
  }
}
