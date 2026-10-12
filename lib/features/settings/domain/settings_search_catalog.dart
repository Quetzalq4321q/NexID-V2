import 'settings_models.dart';

/// Categorias estructuradas del modulo de Ajustes (Secciones 5 y 6).
enum SettingsSectionId {
  appearance(
    'Apariencia y personalizacion',
    'Tema claro, oscuro o automatico y densidad visual de tarjetas',
    false,
  ),
  accessibility(
    'Accesibilidad',
    'Escala de fuente WCAG 2.2, alto contraste, animaciones y lector de pantalla',
    false,
  ),
  performance(
    'Rendimiento',
    'Adaptacion inteligente automatica segun hardware real y ahorro de recursos',
    false,
  ),
  storageCache(
    'Almacenamiento y cache',
    'Presupuesto LRU de imagenes, espacio interno y limpieza temporal segura',
    false,
  ),
  connectivitySync(
    'Conectividad y sincronizacion',
    'Estado de red activa, cola automatica cada 5s y sincronizacion manual',
    false,
  ),
  nfcRecords(
    'NFC y registros',
    'Disponibilidad del lector NFC, medio preferido, sonido, vibracion y guia',
    false,
  ),
  notifications(
    'Notificaciones',
    'Avisos operativos de lectura de credenciales y alertas de cola pendiente',
    false,
  ),
  privacySecurity(
    'Privacidad y seguridad',
    'Operador activo, rol, aislamiento de cache por alcance y reglas protegidas',
    false,
  ),
  appInfo(
    'Informacion de la aplicacion',
    'Version instalada, resumen de hardware detectado y estado operativo',
    false,
  ),
  advanced(
    'Configuracion avanzada',
    'Diagnostico de hardware y seleccion manual de perfil para administradores',
    true,
  );

  const SettingsSectionId(this.title, this.subtitle, this.isRestricted);

  final String title;
  final String subtitle;
  final bool isRestricted;
}

/// Entrada indexada para el buscador local instantaneo de Ajustes.
class SettingSearchEntry {
  const SettingSearchEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.section,
    required this.layer,
    required this.keywords,
  });

  final String id;
  final String title;
  final String subtitle;
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
      keywords: <String>['tema', 'oscuro', 'claro', 'automatico', 'colores', 'apariencia', 'noche'],
    ),
    SettingSearchEntry(
      id: 'compact_density',
      title: 'Densidad visual compacta',
      subtitle: 'Reduce espaciados verticales para pantallas pequenas de 320 px',
      section: SettingsSectionId.appearance,
      layer: SettingLayerType.user,
      keywords: <String>['densidad', 'compacto', 'espacio', 'interfaz', 'tarjetas'],
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
      keywords: <String>['contraste', 'bordes', 'visibilidad', 'wcag', 'lectura'],
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
      subtitle: 'Amplia etiquetas semanticas TalkBack en botones e insignias',
      section: SettingsSectionId.accessibility,
      layer: SettingLayerType.user,
      keywords: <String>['talkback', 'lector', 'voz', 'semantica', 'accesibilidad'],
    ),
    SettingSearchEntry(
      id: 'auto_performance',
      title: 'Perfil automatico e inteligente de rendimiento',
      subtitle: 'Detecta RAM, CPU, bateria y presion de memoria sin ajuste manual',
      section: SettingsSectionId.performance,
      layer: SettingLayerType.automatic,
      keywords: <String>['rendimiento', 'automatico', 'ram', 'memoria', 'procesador', 'optimizacion'],
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
      subtitle: 'Limita precargas secundarias cuando la conexion es medida o inestable',
      section: SettingsSectionId.performance,
      layer: SettingLayerType.user,
      keywords: <String>['datos', 'red', 'movil', 'precarga', 'ahorro'],
    ),
    SettingSearchEntry(
      id: 'cache_cleanup',
      title: 'Limpieza segura de cache temporal e imagenes',
      subtitle: 'Libera memoria grafica y fichas LRU conservando la cola SQLite intacta',
      section: SettingsSectionId.storageCache,
      layer: SettingLayerType.user,
      keywords: <String>['cache', 'almacenamiento', 'limpiar', 'imagenes', 'lru', 'memoria', 'sqlite'],
    ),
    SettingSearchEntry(
      id: 'sync_status',
      title: 'Sincronizacion y cola local de 5 segundos',
      subtitle: 'Estado de conexion, reintento automatico y envio manual a MariaDB',
      section: SettingsSectionId.connectivitySync,
      layer: SettingLayerType.automatic,
      keywords: <String>['sincronizar', 'conectividad', 'internet', 'wifi', 'offline', 'cola', 'mariadb'],
    ),
    SettingSearchEntry(
      id: 'nfc_settings',
      title: 'Lector NFC, QR, vibracion y sonido de lectura',
      subtitle: 'Estado real del chip NFC, medio preferido y guia de validacion en 2 pasadas',
      section: SettingsSectionId.nfcRecords,
      layer: SettingLayerType.user,
      keywords: <String>['nfc', 'qr', 'tarjeta', 'credencial', 'vibracion', 'sonido', 'escaner', 'registro'],
    ),
    SettingSearchEntry(
      id: 'notifications_alerts',
      title: 'Alertas operativas y avisos de sincronizacion',
      subtitle: 'Confirmaciones visuales en lectura y avisos de eventos pendientes',
      section: SettingsSectionId.notifications,
      layer: SettingLayerType.user,
      keywords: <String>['notificaciones', 'alertas', 'avisos', 'sonido', 'pendientes'],
    ),
    SettingSearchEntry(
      id: 'privacy_security',
      title: 'Sesion activa, permisos y politicas protegidas',
      subtitle: 'Cuenta de operador, aislamiento de cache y validacion de seguridad NFC',
      section: SettingsSectionId.privacySecurity,
      layer: SettingLayerType.protectedPolicy,
      keywords: <String>['privacidad', 'seguridad', 'sesion', 'cuenta', 'operador', 'rol', 'cerrar'],
    ),
    SettingSearchEntry(
      id: 'app_hardware_info',
      title: 'Version instalada y capacidades reales del dispositivo',
      subtitle: 'RAM detectada, arquitectura CPU, version de Android y estado del sistema',
      section: SettingsSectionId.appInfo,
      layer: SettingLayerType.automatic,
      keywords: <String>['version', 'informacion', 'hardware', 'android', 'celular', 'dispositivo', 'cpu'],
    ),
    SettingSearchEntry(
      id: 'advanced_manual_profile',
      title: 'Seleccion manual de perfil de rendimiento y simulacion RAM',
      subtitle: 'Permite fijar Rendimiento ligero, equilibrado, completo o perfiles 2-4 GB',
      section: SettingsSectionId.advanced,
      layer: SettingLayerType.advanced,
      keywords: <String>['avanzada', 'manual', 'simulacion', '2gb', '3gb', '4gb', 'administrador', 'diagnostico'],
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
        entry.layer.label,
        ...entry.keywords,
      ].join(' ').toLowerCase();
      return tokens.every(haystack.contains);
    }).toList(growable: false);
  }
}
