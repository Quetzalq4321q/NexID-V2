import 'package:flutter/foundation.dart';
import '../../../../core/platform/hardware_bridge.dart';
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

/// Controlador de captura y coordinacion de lectura fisica NFC y optica QR.
class ReadingController extends ChangeNotifier {
  ReadingController({
    required this._repository,
    HardwareBridge? hardwareBridge,
  }) : _hardwareBridge = hardwareBridge ?? HardwareBridge() {
    _hardwareBridge.setNfcTagListener(_onNativeNfcTagRead);
    refreshHardwareCapabilities();
  }

  final ReadingRepository _repository;
  final HardwareBridge _hardwareBridge;

  ReadingMedium _selectedMedium = ReadingMedium.nfc;
  CaptureState _captureState = CaptureState.idle;
  ResolvedCredential? _lastResult;
  String? _errorMessage;
  String _activePlaceId = 'PL-01';

  NfcHardwareStatus _nfcStatus = NfcHardwareStatus.enabled;
  CameraPermissionStatus _cameraPermission = CameraPermissionStatus.granted;
  String? _lastDetectedUid;
  List<String> _lastDetectedTechs = const [];

  ReadingMedium get selectedMedium => _selectedMedium;
  CaptureState get captureState => _captureState;
  ResolvedCredential? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;
  NfcHardwareStatus get nfcStatus => _nfcStatus;
  CameraPermissionStatus get cameraPermission => _cameraPermission;
  String? get lastDetectedUid => _lastDetectedUid;
  List<String> get lastDetectedTechs => _lastDetectedTechs;

  bool get isNfcAvailable => _nfcStatus == NfcHardwareStatus.enabled;
  bool get isCameraPermissionGranted =>
      _cameraPermission == CameraPermissionStatus.granted;
  List<String> get testTokens => _repository.availableTestTokens;

  Future<void> refreshHardwareCapabilities() async {
    _nfcStatus = await _hardwareBridge.getNfcStatus();
    _cameraPermission = await _hardwareBridge.checkCameraPermission();
    notifyListeners();
  }

  void selectMedium(ReadingMedium medium) {
    if (_selectedMedium != medium) {
      stopListening();
      _selectedMedium = medium;
      _captureState = CaptureState.idle;
      _errorMessage = null;
      refreshHardwareCapabilities();
    }
  }

  Future<void> startListening({String placeId = 'PL-01'}) async {
    _activePlaceId = placeId;
    _errorMessage = null;

    if (_selectedMedium == ReadingMedium.nfc) {
      await _startNfcCapture();
    } else {
      await _startQrCapture();
    }
  }

  Future<void> _startNfcCapture() async {
    _nfcStatus = await _hardwareBridge.getNfcStatus();
    if (_nfcStatus == NfcHardwareStatus.notSupported) {
      _errorMessage =
          'Este dispositivo no dispone de hardware NFC. Cambie a modalidad QR.';
      _captureState = CaptureState.error;
      notifyListeners();
      return;
    }
    if (_nfcStatus == NfcHardwareStatus.disabled) {
      _errorMessage =
          'El antena NFC esta desactivada. Activelo en la configuracion de Android.';
      _captureState = CaptureState.error;
      notifyListeners();
      return;
    }

    final bool started = await _hardwareBridge.startNfcReader();
    if (started) {
      _captureState = CaptureState.listening;
    } else {
      _errorMessage = 'No fue posible iniciar el lector NFC del sistema.';
      _captureState = CaptureState.error;
    }
    notifyListeners();
  }

  Future<void> _startQrCapture() async {
    _cameraPermission = await _hardwareBridge.requestCameraPermission();
    if (_cameraPermission != CameraPermissionStatus.granted) {
      _errorMessage =
          'Permiso de camara requerido para escanear codigos QR en vivo.';
      _captureState = CaptureState.error;
      notifyListeners();
      return;
    }

    _captureState = CaptureState.listening;
    notifyListeners();

    try {
      final String? qrToken = await _hardwareBridge.scanQrCode();
      if (qrToken != null && qrToken.isNotEmpty) {
        await simulateScan(
          token: qrToken,
          placeId: _activePlaceId,
          forceMedium: ReadingMedium.qr,
        );
      }
    } catch (_) {
      _errorMessage =
          'No se pudo completar el escaneo optico QR. Intente nuevamente.';
      _captureState = CaptureState.error;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _hardwareBridge.stopNfcReader();
    if (_captureState == CaptureState.listening) {
      _captureState = CaptureState.idle;
      notifyListeners();
    }
  }

  void _onNativeNfcTagRead(NfcTagEvent event) {
    if (_captureState == CaptureState.resolving) return;
    _lastDetectedUid = event.uid;
    _lastDetectedTechs = event.techList;
    simulateScan(
      token: event.token,
      placeId: _activePlaceId,
      forceMedium: ReadingMedium.nfc,
    );
  }

  Future<void> requestCameraPermissionExplicit() async {
    _cameraPermission = await _hardwareBridge.requestCameraPermission();
    if (_cameraPermission == CameraPermissionStatus.granted) {
      _errorMessage = null;
      if (_captureState == CaptureState.error) {
        _captureState = CaptureState.idle;
      }
    }
    notifyListeners();
  }

  Future<void> openSystemNfcSettings() async {
    await _hardwareBridge.openNfcSettings();
  }

  Future<void> openSystemAppSettings() async {
    await _hardwareBridge.openAppSettings();
  }

  Future<void> simulateScan({
    required String token,
    required String placeId,
    ReadingMedium? forceMedium,
  }) async {
    final String cleanToken = token.trim();
    if (cleanToken.isEmpty) return;

    final ReadingMedium effectiveMedium = forceMedium ?? _selectedMedium;
    _selectedMedium = effectiveMedium;
    _captureState = CaptureState.resolving;
    _errorMessage = null;
    notifyListeners();

    try {
      final ResolvedCredential result = await _repository.resolveCredential(
        token: cleanToken,
        medium: effectiveMedium,
        placeId: placeId,
      );
      _lastResult = result;
      _captureState = CaptureState.resolved;
    } catch (e) {
      _errorMessage = 'Error al procesar la credencial leida.';
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

  @override
  void dispose() {
    _hardwareBridge.setNfcTagListener(null);
    _hardwareBridge.stopNfcReader();
    super.dispose();
  }
}
