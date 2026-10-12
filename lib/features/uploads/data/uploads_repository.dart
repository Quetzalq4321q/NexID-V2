/// Repositorio local de subida de archivos segun agent/16_ARCHIVOS.md.
/// Valida reglas estrictas: formatos admitidos (jpg, png, webp) y tamano maximo (2 MB).
class UploadsRepository {
  static const int maxSizeBytes = 2 * 1024 * 1024; // 2 MB
  static const Set<String> allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  String? validateFile(String fileName, int sizeBytes) {
    final String extension =
        fileName.split('.').last.toLowerCase().replaceAll('.', '');
    if (!allowedExtensions.contains(extension)) {
      return 'Formato no admitido. Permitidos: JPG, PNG, WebP.';
    }
    if (sizeBytes > maxSizeBytes) {
      return 'El archivo supera el limite maximo de 2 MB.';
    }
    return null;
  }
}
