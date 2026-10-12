/// Formateador de fechas estandar para la interfaz local.
abstract final class DateFormatter {
  static String formatDateTime(DateTime dateTime) {
    final String y = dateTime.year.toString().padLeft(4, '0');
    final String m = dateTime.month.toString().padLeft(2, '0');
    final String d = dateTime.day.toString().padLeft(2, '0');
    final String h = dateTime.hour.toString().padLeft(2, '0');
    final String min = dateTime.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  static String formatTimeOnly(DateTime dateTime) {
    final String h = dateTime.hour.toString().padLeft(2, '0');
    final String min = dateTime.minute.toString().padLeft(2, '0');
    final String s = dateTime.second.toString().padLeft(2, '0');
    return '$h:$min:$s';
  }
}
