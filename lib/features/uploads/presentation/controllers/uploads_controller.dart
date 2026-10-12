import 'package:flutter/foundation.dart';
import '../../data/uploads_repository.dart';
import '../../domain/upload_models.dart';

/// Controlador de subida de archivos y seguimiento del progreso.
class UploadsController extends ChangeNotifier {
  UploadsController({required UploadsRepository repository})
      : _repository = repository;

  final UploadsRepository _repository;
  final List<UploadFileItem> _items = [];

  List<UploadFileItem> get items => List.unmodifiable(_items);

  Future<void> simulateFileUpload({
    required String fileName,
    required int fileSizeBytes,
    required String purpose,
  }) async {
    final String? validationError =
        _repository.validateFile(fileName, fileSizeBytes);

    final String itemId = 'UP-${DateTime.now().millisecondsSinceEpoch}';
    final UploadFileItem item = UploadFileItem(
      id: itemId,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      purpose: purpose,
      progress: 0.0,
      status: validationError != null
          ? UploadStatus.error
          : UploadStatus.uploading,
      errorMessage: validationError,
    );

    _items.insert(0, item);
    notifyListeners();

    if (validationError != null) return;

    // Simulacion de carga progresiva
    for (int step = 1; step <= 5; step++) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final int idx = _items.indexWhere((i) => i.id == itemId);
      if (idx != -1) {
        final double currentProgress = step * 0.2;
        _items[idx] = _items[idx].copyWith(
          progress: currentProgress,
          status: step == 5 ? UploadStatus.completed : UploadStatus.uploading,
        );
        notifyListeners();
      }
    }
  }
}
