import 'package:flutter/material.dart';
import 'settings_models.dart';

/// Categorias oficiales del modulo de Configuracion en el orden visual definitivo.
/// Las 8 primeras conforman la lista principal; `advanced` permanece oculta y restringida.
enum SettingsSectionId {
  appearance(
    'Apariencia y personalizacion',
    'Tema, estilo y visualizacion.',
    Icons.palette_outlined,
    false,
  ),
  accessibility(
    'Accesibilidad',
    'Texto, contraste y movimiento.',
    Icons.accessibility_new_outlined,
    false,
  ),
  performance(
    'Rendimiento',
    'Optimizacion automatica.',
    Icons.speed_outlined,
    false,
  ),
  storageCache(
    'Almacenamiento y cache',
    'Archivos temporales y espacio.',
    Icons.storage_outlined,
    false,
  ),
  connectivitySync(
    'Conectividad y sincronizacion',
    'Estado de conexion y datos.',
    Icons.sync_outlined,
    false,
  ),
  nfcRecords(
    'NFC y registros',
    'Lector, validacion y actividad.',
    Icons.nfc_outlined,
    false,
  ),
  privacySecurity(
    'Privacidad y seguridad',
    'Proteccion y sesion.',
    Icons.shield_outlined,
    false,
  ),
  appInfo(
    'Acerca de la aplicacion',
    'Version y soporte.',
    Icons.info_outline,
    false,
  ),
  advanced(
    'Configuracion avanzada',
    'Perfil manual, limites de cache, concurrencia y diagnostico NFC.',
    Icons.tune_outlined,
    true,
  );

  const SettingsSectionId(
    this.title,
    this.subtitle,
    this.icon,
    this.isRestricted,
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isRestricted;

  /// Las 8 categorias publicas en el orden exacto requerido por el diseno.
  static List<SettingsSectionId> get publicSections =>
      values.where((SettingsSectionId s) => !s.isRestricted).toList();
}

/// Entrada indexada para el buscador local instantaneo de Configuracion.
class SettingSearchEntry {
  const SettingSearchEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.section,
    required this.layer,
    required this.keywords,
  });
  final String id, title, subtitle;
  final SettingsSectionId section;
  final SettingLayerType layer;
  final List<String> keywords;
}

/// Catalogo estatico e inmutable de busqueda local de configuraciones.
class SettingsSearchCatalog {
  const SettingsSearchCatalog._();
  static const List<SettingSearchEntry> entries = <SettingSearchEntry>[
    SettingSearchEntry(
      id: 'theme_mode',
      title: 'Modo de tema (Claro, Oscuro, Automatico)',
      subtitle: 'Sincroniza con el sistema operativo o fija apariencia visual',
      section: SettingsSectionId.appearance,
      layer: SettingLayerType.user,
      keywords: <String>['tema', 'oscuro', 'claro', 'automatico', 'colores', 'apariencia', 'estilo'],
    ),
    SettingSearchEntry(
      id: 'compact_density',
      title: 'Densidad visual compacta',
      subtitle: 'Adapta espaciados verticales para pantallas pequenas',
      section: SettingsSectionId.appearance,
      layer: SettingLayerType.user,
      keywords: <String>['densidad', 'compacto', 'espacio', 'visualizacion', 'tarjetas'],
    ),
    SettingSearchEntry(
      id: 'font_scale',
      title: 'Tamano de texto y escala tipografica',
      subtitle: 'Escalas de 90%, 100%, 115% y 130% conforme a WCAG 2.2',
      section: SettingsSectionId.accessibility,
      layer: SettingLayerType.user,
      keywords: <String>['fuente', 'letra', 'texto', 'tamano', 'escala', 'wcag', 'accesibilidad'],
    ),
    SettingSearchEntry(
      id: 'high_contrast',
      title: 'Modo de alto contraste WCAG 2.2',
      subtitle: 'Refuerza bordes, textos e indicadores de estado',
      section: SettingsSectionId.accessibility,
      layer: SettingLayerType.user,
      keywords: <String>['contraste', 'bordes', 'visibilidad', 'wcag'],
    ),
    SettingSearchEntry(
      id: 'reduce_motion',
      title: 'Reducir animaciones y movimiento',
      subtitle: 'Usa skeletons estaticos y transiciones instantaneas',
      section: SettingsSectionId.accessibility,
      layer: SettingLayerType.user,
      keywords: <String>['animaciones', 'movimiento', 'shimmer', 'skeleton', 'fluidez'],
    ),
    SettingSearchEntry(
      id: 'screen_reader',
      title: 'Compatibilidad con lector de pantalla',
      subtitle: 'Amplia etiquetas semanticas TalkBack en controles',
      section: SettingsSectionId.accessibility,
      layer: SettingLayerType.user,
      keywords: <String>['talkback', 'lector', 'voz', 'semantica'],
    ),
    SettingSearchEntry(
      id: 'auto_performance',
      title: 'Optimizacion automatica del dispositivo',
      subtitle: 'Adapta consumo de recursos segun capacidades reales de Android',
      section: SettingsSectionId.performance,
      layer: SettingLayerType.automatic,
      keywords: <String>['rendimiento', 'automatico', 'ram', 'memoria', 'optimizacion'],
    ),
    SettingSearchEntry(
      id: 'low_performance_mode',
      title: 'Modo de ahorro de recursos visuales',
      subtitle: 'Prioriza respuesta tactil y lectura NFC sobre efectos visuales',
      section: SettingsSectionId.performance,
      layer: SettingLayerType.user,
      keywords: <String>['ahorro', 'ligero', 'gama baja', 'fluidez', 'velocidad'],
    ),
    SettingSearchEntry(
      id: 'data_saver',
      title: 'Ahorro de datos y carga diferida en red movil',
      subtitle: 'Limita precargas secundarias cuando la conexion es inestable',
      section: SettingsSectionId.performance,
      layer: SettingLayerType.user,
      keywords: <String>['datos', 'red', 'movil', 'precarga', 'ahorro'],
    ),
    SettingSearchEntry(
      id: 'cache_cleanup',
      title: 'Limpieza segura de archivos temporales y cache',
      subtitle: 'Libera memoria grafica y fichas LRU conservando la cola SQLite intacta',
      section: SettingsSectionId.storageCache,
      layer: SettingLayerType.user,
      keywords: <String>['cache', 'almacenamiento', 'limpiar', 'imagenes', 'lru', 'espacio', 'sqlite'],
    ),
    SettingSearchEntry(
      id: 'sync_status',
      title: 'Conectividad, sincronizacion y avisos de cola de 5s',
      subtitle: 'Estado de conexion, alertas de pendientes y envio manual a MariaDB',
      section: SettingsSectionId.connectivitySync,
      layer: SettingLayerType.automatic,
      keywords: <String>['sincronizar', 'conectividad', 'internet', 'wifi', 'cola', 'mariadb', 'notificaciones'],
    ),
    SettingSearchEntry(
      id: 'nfc_settings',
      title: 'Lector NFC, QR, vibracion, sonido y alertas de lectura',
      subtitle: 'Estado del chip NFC, medio preferido y validacion en 2 pasadas',
      section: SettingsSectionId.nfcRecords,
      layer: SettingLayerType.user,
      keywords: <String>['nfc', 'qr', 'tarjeta', 'credencial', 'vibracion', 'sonido', 'escaner', 'registro', 'alertas'],
    ),
    SettingSearchEntry(
      id: 'privacy_security',
      title: 'Privacidad, sesion activa y politicas protegidas',
      subtitle: 'Cuenta de operador, permisos de rol, cierre de sesion y reglas inmutables',
      section: SettingsSectionId.privacySecurity,
      layer: SettingLayerType.protectedPolicy,
      keywords: <String>['privacidad', 'seguridad', 'sesion', 'cuenta', 'operador', 'rol', 'cerrar'],
    ),
    SettingSearchEntry(
      id: 'app_hardware_info',
      title: 'Acerca de la aplicacion, version y soporte de hardware',
      subtitle: 'Version instalada, RAM detectada, arquitectura CPU y estado del sistema',
      section: SettingsSectionId.appInfo,
      layer: SettingLayerType.automatic,
      keywords: <String>['acerca', 'version', 'informacion', 'hardware', 'android', 'celular', 'soporte', 'cpu'],
    ),
    SettingSearchEntry(
      id: 'advanced_manual_profile',
      title: 'Configuracion avanzada: perfil manual, concurrencia y diagnostico',
      subtitle: 'Permite fijar Rendimiento ligero, equilibrado, completo o perfiles 2-4 GB',
      section: SettingsSectionId.advanced,
      layer: SettingLayerType.advanced,
      keywords: <String>['avanzada', 'manual', 'simulacion', '2gb', '3gb', '4gb', 'administrador', 'diagnostico', 'concurrencia'],
    ),
  ];

  static List<SettingSearchEntry> search(
    String rawQuery, {
    required bool canAccessAdvanced,
  }) {
    final Iterable<SettingSearchEntry> visible = entries.where(
      (SettingSearchEntry e) => canAccessAdvanced || !e.section.isRestricted,
    );
    final String query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return visible.toList(growable: false);
    }
    final List<String> tokens =
        query.split(RegExp(r'\s+')).where((String s) => s.isNotEmpty).toList();
    return visible.where((SettingSearchEntry entry) {
      final String haystack = <String>[
        entry.title,
        entry.subtitle,
        entry.section.title,
        entry.section.subtitle,
        entry.layer.label,
        ...entry.keywords,
      ].join(' ').toLowerCase();
      return tokens.every(haystack.contains);
    }).toList(growable: false);
  }
}
