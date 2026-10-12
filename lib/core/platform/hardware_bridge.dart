import 'package:flutter/services.dart';

/// Estado real del adaptador fisico NFC en el dispositivo Android.
enum NfcHardwareStatus {
  enabled('NFC Activo'),
  disabled('NFC Desactivado'),
  notSupported('Sin hardware NFC');

  const NfcHardwareStatus(this.label);
  final String label;
}

/// Estado del permiso en tiempo de ejecucion de camara para lectura QR.
enum CameraPermissionStatus {
  granted('Permiso Concedido'),
  denied('Permiso Pendiente'),
  permanentlyDenied('Permiso Bloqueado en Ajustes');

  const CameraPermissionStatus(this.label);
  final String label;
}

/// Datos extraidos de una tarjeta NFC fisica (NDEF o UID hexadecimal).
class NfcTagEvent {
  const NfcTagEvent({
    required this.token,
    required this.uid,
    required this.techList,
  });

  final String token;
  final String uid;
  final List<String> techList;
}

/// Puente de comunicacion con la capa nativa Kotlin (NFC Reader Mode y Camara QR).
class HardwareBridge {
  HardwareBridge() {
    _channel.setMethodCallHandler(_handleNativeCallback);
  }

  static const MethodChannel _channel =
      MethodChannel('com.nexlabs.nexid/hardware');

  void Function(NfcTagEvent event)? _onNfcTagRead;

  void setNfcTagListener(void Function(NfcTagEvent event)? listener) {
    _onNfcTagRead = listener;
  }

  Future<dynamic> _handleNativeCallback(MethodCall call) async {
    if (call.method == 'onNfcTagRead' && call.arguments is Map) {
      final Map<dynamic, dynamic> map = call.arguments as Map<dynamic, dynamic>;
      final String token = (map['token'] as String?) ?? '';
      final String uid = (map['uid'] as String?) ?? '';
      final List<String> techList = (map['techList'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList() ??
          const <String>[];

      if (token.isNotEmpty) {
        _onNfcTagRead?.call(
          NfcTagEvent(token: token, uid: uid, techList: techList),
        );
      }
    }
  }

  Future<NfcHardwareStatus> getNfcStatus() async {
    try {
      final String? status = await _channel.invokeMethod<String>('getNfcStatus');
      return switch (status) {
        'enabled' => NfcHardwareStatus.enabled,
        'disabled' => NfcHardwareStatus.disabled,
        'not_supported' => NfcHardwareStatus.notSupported,
        _ => NfcHardwareStatus.enabled,
      };
    } on MissingPluginException {
      return NfcHardwareStatus.enabled;
    } on PlatformException {
      return NfcHardwareStatus.disabled;
    }
  }

  Future<bool> startNfcReader() async {
    try {
      final bool? started =
          await _channel.invokeMethod<bool>('startNfcReader');
      return started ?? false;
    } on MissingPluginException {
      return true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> stopNfcReader() async {
    try {
      await _channel.invokeMethod<bool>('stopNfcReader');
    } on MissingPluginException {
      // Ignorado en entorno de pruebas sin canal nativo
    } on PlatformException {
      // Ignorado si ya estaba detenido
    }
  }

  Future<void> openNfcSettings() async {
    try {
      await _channel.invokeMethod<bool>('openNfcSettings');
    } on MissingPluginException {
      // Entorno simulado
    }
  }

  Future<CameraPermissionStatus> checkCameraPermission() async {
    try {
      final String? status =
          await _channel.invokeMethod<String>('checkCameraPermission');
      return _parseCameraStatus(status);
    } on MissingPluginException {
      return CameraPermissionStatus.granted;
    } on PlatformException {
      return CameraPermissionStatus.denied;
    }
  }

  Future<CameraPermissionStatus> requestCameraPermission() async {
    try {
      final String? status =
          await _channel.invokeMethod<String>('requestCameraPermission');
      return _parseCameraStatus(status);
    } on MissingPluginException {
      return CameraPermissionStatus.granted;
    } on PlatformException {
      return CameraPermissionStatus.denied;
    }
  }

  Future<String?> scanQrCode() async {
    try {
      return await _channel.invokeMethod<String>('scanQrCode');
    } on MissingPluginException {
      return null;
    }
  }

  Future<void> openAppSettings() async {
    try {
      await _channel.invokeMethod<bool>('openAppSettings');
    } on MissingPluginException {
      // Entorno simulado
    }
  }

  CameraPermissionStatus _parseCameraStatus(String? raw) {
    return switch (raw) {
      'granted' => CameraPermissionStatus.granted,
      'permanently_denied' => CameraPermissionStatus.permanentlyDenied,
      _ => CameraPermissionStatus.denied,
    };
  }
}
