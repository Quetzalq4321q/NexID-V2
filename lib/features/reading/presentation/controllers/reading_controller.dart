import 'package:flutter/foundation.dart';
import '../../data/reading_repository.dart';
import '../../domain/credential_models.dart';

/// Estado de la captura de lectura segun agent/13_NFC_QR.md.
enum CaptureState {
  idle,
  listening,
  resolving,
  resolved,
  error,
}

/// Controlador de captura y coordinacion de lectura NFC/QR.
class ReadingController extends ChangeNotifier {
  ReadingController({required ReadingRepository repository})
      : _repository = repository;

  final ReadingRepository _repository;

  ReadingMedium _selectedMedium = ReadingMedium.nfc;
  CaptureState _captureState = CaptureState.idle;
  ResolvedCredential? _lastResult;
  String? _errorMessage;

  // Estados de hardware y permisos
  bool _isNfcAvailable = true;
  bool _isCameraPermissionGranted = true;

  ReadingMedium get selectedMedium => _selectedMedium;
  CaptureState get captureState => _captureState;
  ResolvedCredential? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;
  bool get isNfcAvailable => _isNfcAvailable;
  bool get isCameraPermissionGranted => _isCameraPermissionGranted;
  List<String> get testTokens => _repository.availableTestTokens;

  void selectMedium(ReadingMedium medium) {
    if (_selectedMedium != medium) {
      _selectedMedium = medium;
      _captureState = CaptureState.idle;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void startListening() {
    _captureState = CaptureState.listening;
    _errorMessage = null;
    notifyListeners();
  }

  void stopListening() {
    if (_captureState == CaptureState.listening) {
      _captureState = CaptureState.idle;
      notifyListeners();
    }
  }

  Future<void> simulateScan({
    required String token,
    required String placeId,
  }) async {
    _captureState = CaptureState.resolving;
    _errorMessage = null;
    notifyListeners();

    try {
      final ResolvedCredential result = await _repository.resolveCredential(
        token: token,
        medium: _selectedMedium,
        placeId: placeId,
      );
      _lastResult = result;
      _captureState = CaptureState.resolved;
    } catch (e) {
      _errorMessage = 'Error al procesar la credencial solicitada.';
      _captureState = CaptureState.error;
    }

    notifyListeners();
  }

  void resetCapture() {
    _captureState = CaptureState.idle;
    _lastResult = null;
    _errorMessage = null;
    notifyListeners();
  }
}
