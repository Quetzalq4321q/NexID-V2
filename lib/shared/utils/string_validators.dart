/// Validadores simples para entradas de usuario.
abstract final class StringValidators {
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool isValidCode(String? value) {
    if (value == null) return false;
    final String trimmed = value.trim();
    return trimmed.length >= 4 && trimmed.length <= 32;
  }
}
