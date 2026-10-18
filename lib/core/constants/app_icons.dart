import 'package:flutter/material.dart';

/// Catalogo centralizado de iconos oficiales para toda la aplicacion NexID.
/// Garantiza consistencia visual, jerarquia y nitidez en todas las pantallas.
abstract final class AppIcons {
  // --- Identidad y Modulos Principales ---
  static const IconData appEmblem = Icons.nfc;
  static const IconData nfc = Icons.nfc_outlined;
  static const IconData qr = Icons.qr_code_scanner_outlined;
  static const IconData qrFilled = Icons.qr_code_scanner;
  static const IconData records = Icons.list_alt_outlined;
  static const IconData recordsFilled = Icons.list_alt;
  static const IconData students = Icons.people_alt_outlined;
  static const IconData studentsFilled = Icons.people_alt;
  static const IconData reports = Icons.assessment_outlined;
  static const IconData reportsFilled = Icons.assessment;
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsFilled = Icons.settings;

  // --- Navegacion y Acciones ---
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.chevron_right;
  static const IconData close = Icons.close;
  static const IconData clear = Icons.clear_outlined;
  static const IconData search = Icons.search_outlined;
  static const IconData searchOff = Icons.search_off_outlined;
  static const IconData sync = Icons.sync_outlined;
  static const IconData refresh = Icons.refresh_outlined;
  static const IconData filter = Icons.filter_list_outlined;
  static const IconData sort = Icons.swap_vert_outlined;
  static const IconData login = Icons.login_outlined;
  static const IconData logout = Icons.logout_outlined;
  static const IconData download = Icons.download_outlined;
  static const IconData restore = Icons.restore_outlined;

  // --- Estados Semanticos y Retroalimentacion ---
  static const IconData success = Icons.check_circle_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData info = Icons.info_outline;
  static const IconData verified = Icons.verified_outlined;
  static const IconData emptyInbox = Icons.inbox_outlined;
  static const IconData cloudOff = Icons.cloud_off_outlined;
  static const IconData cloudDone = Icons.cloud_done_outlined;
  static const IconData lock = Icons.lock_outline;
  static const IconData shield = Icons.shield_outlined;
  static const IconData admin = Icons.admin_panel_settings_outlined;

  // --- Hardware y Deteccion de Capacidades ---
  static const IconData cpu = Icons.memory_outlined;
  static const IconData speed = Icons.speed_outlined;
  static const IconData storage = Icons.storage_outlined;
  static const IconData battery = Icons.battery_charging_full_outlined;
  static const IconData wifi = Icons.wifi_outlined;
  static const IconData tune = Icons.tune_outlined;

  // --- Apariencia y Accesibilidad ---
  static const IconData themeLight = Icons.wb_sunny_outlined;
  static const IconData themeDark = Icons.nights_stay_outlined;
  static const IconData themeAuto = Icons.brightness_auto_outlined;
  static const IconData palette = Icons.palette_outlined;
  static const IconData accessibility = Icons.accessibility_new_outlined;
  static const IconData fontScale = Icons.format_size_outlined;
  static const IconData motion = Icons.animation_outlined;
  static const IconData screenReader = Icons.record_voice_over_outlined;
}
