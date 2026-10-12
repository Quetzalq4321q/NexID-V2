/// Estado de la subida de archivo segun agent/16_ARCHIVOS.md.
enum UploadStatus {
  idle,
  uploading,
  completed,
  error,
}

/// Elemento de archivo en cola de subida con proposito validado.
class UploadFileItem {
  const UploadFileItem({
    required this.id,
    required this.fileName,
    required this.fileSizeBytes,
    required this.purpose,
    required this.progress,
    required this.status,
    this.errorMessage,
  });

  final String id;
  final String fileName;
  final int fileSizeBytes;
  final String purpose;
  final double progress;
  final UploadStatus status;
  final String? errorMessage;

  String get formattedSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  UploadFileItem copyWith({
    double? progress,
    UploadStatus? status,
    String? errorMessage,
  }) {
    return UploadFileItem(
      id: id,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
      purpose: purpose,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
