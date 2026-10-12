# Changelog

## [0.0.9+9] - 2026-10-12 — VIS-SETTINGS-FINAL (Diseno Visual Definitivo de Configuracion, Tarjeta de Optimizacion Automatica y 8 Categorias Dedicadas)
- Cambio: Implementacion del diseno visual definitivo del apartado **Configuracion** (`SettingsPage`): encabezado compacto con flecha de regreso (`Icons.arrow_back`), titulo «Configuracion» e icono de ajustes alineado (`SettingsHeaderBar`); barra de busqueda redondeada «Buscar un ajuste...» con filtrado y navegacion directa; tarjeta destacada **Optimizacion del dispositivo** (`DeviceOptimizationBannerCard`) conectada al estado real de deteccion (`isDetectionCompleted` -> `Estado: Automatica`); lista vertical ordenada de 8 categorias (`Apariencia y personalizacion`, `Accesibilidad`, `Rendimiento`, `Almacenamiento y cache`, `Conectividad y sincronizacion`, `NFC y registros`, `Privacidad y seguridad`, `Acerca de la aplicacion`) con navegacion a subpantallas dedicadas; paleta en tonos neutros y variantes azules sin acentos morados; y **Configuracion avanzada** oculta de la lista principal y protegida por permisos reales de Administrador (`SessionController.canAccessAdvancedSettings`).
- Modulos y componentes intervenidos:
  - `lib/features/settings/`: `device_optimization_banner.dart`, `settings_page.dart`, `settings_search_catalog.dart`, `settings_controller.dart`, `settings_system_sections.dart`.
  - `lib/core/`: `app_colors.dart`, `nexid_palette.dart`, `hardware_bridge.dart`, `app_version.dart`, `app_shell.dart`.
  - `docs/` y `test/`: `DEVICE_CAPABILITIES_SETTINGS.md`, `THEMES_ACCESSIBILITY.md`, `DECISIONS.md`, `PROGRESS.md`, `widget_test.dart`, `device_capabilities_settings_test.dart`.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo y funciones <40 lineas).
- Pruebas: 8/8 aprobadas en `flutter test` y 0 advertencias en `flutter analyze`.

## [0.0.8+8] - 2026-10-12 — HW-AUTO-SETTINGS (Deteccion Real de Hardware Android, Adaptacion Inteligente de Rendimiento, Buscador de Ajustes y Configuracion Avanzada Restringida)
- Cambio: Implementacion en Kotlin (`DeviceCapabilitiesManager.kt`) y Dart (`DeviceCapabilitiesSnapshot`) de deteccion real de capacidades del dispositivo (RAM total/disponible, `isLowRamDevice`, heap del proceso, arquitectura y nucleos CPU, almacenamiento libre, version de Android, OpenGL/Vulkan, NFC, ahorro de bateria, estado termico y conectividad) sin inventar valores cuando el SO no los expone; perfil automatico e inteligente de rendimiento activo por defecto (`isAutoPerformance = true`, niveles `Rendimiento ligero`, `equilibrado` y `completo`); reorganizacion completa de `SettingsPage` en 9 secciones operativas + 10ma seccion de **Configuracion avanzada** restringida a `UserRole.administrador` o autorizacion verificada en `SessionController`; y buscador local instantaneo en la parte superior de Ajustes (`SettingsSearchCatalog`).
- Modulos y componentes intervenidos:
  - `android/app/src/main/kotlin/com/nexlabs/nexid/`: `DeviceCapabilitiesManager.kt`, `MainActivity.kt`, `AndroidManifest.xml`.
  - `lib/core/platform/` y `lib/core/performance/`: `device_capabilities_models.dart`, `hardware_bridge.dart`, `device_performance_tier.dart`.
  - `lib/features/settings/`: `settings_models.dart`, `settings_search_catalog.dart`, `settings_controller.dart`, `settings_page.dart`, `low_end_performance_card.dart`, `settings_system_sections.dart`, `advanced_settings_card.dart`, `theme_appearance_card.dart`.
  - `lib/features/session/`: `session_models.dart`, `session_controller.dart`.
  - `docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`, `AGENTS.md`, `docs/PROGRESS.md`, `docs/DECISIONS.md`.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo y funciones <40 lineas).
- Pruebas: 8/8 aprobadas en `flutter test` (`widget_test.dart`, `performance_low_end_test.dart`, `device_capabilities_settings_test.dart`) y 0 advertencias en `flutter analyze`.

## [0.0.7+7] - 2026-10-12 — PERF-0 (PRIORIDAD 0: Optimizacion Extrema para Dispositivos Android de Gama Baja 2-4 GB RAM y Memoria Tecnica entre Agentes)
- Cambio: Implementacion integral de Prioridad 0 para celulares Android economicos (Samsung Galaxy A13, Galaxy A14, Redmi 15C, 2 GB / 3 GB / 4 GB RAM) con perfiles de hardware simulables (`DevicePerformanceProfile`), guardian de memoria RAM (`DeviceMemoryGuard` ante `didHaveMemoryPressure` y `AppLifecycleState.paused`), cache LRU acotada con deduplicacion en vuelo (`BoundedLruCache`), planificador por prioridades (`PriorityTaskScheduler`: lectura NFC en `TaskPriority.critical`, listas en `medium`, reportes PDF en `low` + `Isolate.run`), proyeccion ligera en listado de alumnos con hidratacion diferida de fichas, busqueda con debounce y sistema de memoria tecnica persistente en `AGENTS.md` y `docs/`.
- Modulos y componentes intervenidos:
  - `lib/core/performance/`: `device_performance_tier.dart`, `priority_task_scheduler.dart`, `bounded_lru_cache.dart`.
  - `lib/features/settings/`: `low_end_performance_card.dart`, `settings_models.dart`, `settings_controller.dart`, `settings_page.dart`.
  - `lib/features/students/`, `records/`, `reading/` y `reports/`: proyeccion ligera, cache LRU, debounce, `RepaintBoundary` y `TaskPriority.critical`.
  - `AGENTS.md`, `docs/DECISIONS.md`, `docs/PROGRESS.md` y `docs/missions/`: documentacion centralizada de continuidad entre agentes.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo).
- Pruebas: 100% aprobadas (`test/widget_test.dart` + 12 escenarios de gama baja en `test/performance_low_end_test.dart`) y 0 advertencias en `flutter analyze`.

## [0.0.6+6] - 2026-10-12 — VIS-F / FUN-3 (Accesibilidad WCAG 2.2, Temas Independientes Claro/Oscuro, Skeleton Loading, Ampliacion de Alumnos/Registros y Vista Previa PDF A4)
- Cambio: Implementacion integral de accesibilidad WCAG 2.2 con deteccion automatica del tema del SO (`Claro`, `Oscuro`, `Automatico`), tokens semanticos independientes (`NexIdPalette`), escala tipografica (90%-130%), alto contraste y reduccion de movimiento; sistema global de Skeleton Loading (`DataStateBoundary`, `ShimmerBox`, `StudentListSkeleton`, `RecordListSkeleton`); ampliacion del modulo de alumnos en 3 pestañas (`Personal`, `Academico`, `Seguimiento` con datos demo identificados); enriquecimiento del modulo de registros con KPIs, busqueda avanzada, paginacion progresiva y hoja modal de auditoria (`RecordDetailSheet`); y muestra interactiva de documento PDF en formato A4 (`PdfPreviewPage`, `PdfA4SheetWidget`).
- Modulos y componentes intervenidos:
  - `nexid_palette.dart` y `app_theme.dart`: tokens semanticos independientes Claro/Oscuro/Alto Contraste.
  - `settings/`: `ThemeAppearanceCard`, `AccessibilityControlsCard`, `SettingsController`, `SettingsPage`.
  - `skeleton/`: `shimmer_skeleton.dart`, `module_skeletons.dart`.
  - `students/`: `student_models.dart`, `students_repository.dart`, `students_controller.dart`, `students_page.dart`, `student_full_profile_page.dart`, `student_profile_tabs.dart`.
  - `records/`: `record_models.dart`, `records_repository.dart`, `records_controller.dart`, `records_page.dart`, `record_detail_sheet.dart`.
  - `reports/`: `pdf_preview_page.dart`, `pdf_a4_sheet_widget.dart`, `pdf_a4_sections_widget.dart`, `reports_page.dart`.
  - `AGENTS.md` y `agent/24_ACCESIBILIDAD_Y_TEMAS.md`: documentacion arquitectonica completa.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo).
- Pruebas: 100% aprobadas con `flutter test` en modos Claro y Oscuro y 0 advertencias en `flutter analyze`.

## [0.0.5+5] - 2026-10-12 — FUN-2 / VIS-E (Lectura Fisica NFC, Escaneo QR con Permisos en Tiempo de Ejecucion y AndroidManifest.xml)
- Cambio: Integracion nativa completa en Kotlin para lectura de tarjetas NFC (`NfcAdapter.enableReaderMode`, NDEF y UID hexadecimal) y escaneo optico QR (`GmsBarcodeScanning`) con solicitud de permisos `android.permission.CAMERA` en tiempo de ejecucion, filtros de intent NFC y recursos XML (`nfc_tech_filter.xml`).
- Modulos y componentes intervenidos:
  - `AndroidManifest.xml` y `res/xml/nfc_tech_filter.xml`: permisos, hardware features opcionales e intent-filters NFC.
  - `NfcHardwareManager.kt`, `CameraQrManager.kt` y `MainActivity.kt`: implementacion 100% en Kotlin (cero Java).
  - `hardware_bridge.dart`, `scanner_status_card.dart`, `reading_controller.dart` y `reading_page.dart`: puente Dart, controles de permisos e interfaz reactiva.
  - `app_version.dart` y `pubspec.yaml`: incremento a `0.0.5+5`.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo).
- Pruebas: 100% aprobadas con `flutter test` y 0 advertencias en `flutter analyze`.

## [0.0.4+4] - 2026-10-12 — VIS-D (Desplegable Unificado en Registros y Versionado Interno)
- Cambio: Sustitucion de chips horizontales en Registros por `RecordsFilterDropdown` (desplegable con criterios de sincronizacion y tipo, orden cronologico reactivo y contador), creacion de `AppVersion` (0.0.4+4) y actualizacion sincronizada de `pubspec.yaml`, `SettingsPage` y suite de pruebas.
- Modulos y componentes intervenidos:
  - `records_filter_dropdown.dart`: nuevo widget con dropdown de criterios, icono `tune`, boton de orden y badge de total.
  - `records_controller.dart`: soporte para `RecordFilterCriteria` (`all`, `pending`, `confirmed`, `reviewRequired`, `entrada`, `salida`) y orden cronologico `sortDescending`.
  - `records_page.dart`: sustitucion de la barra de `ChoiceChip` horizontales.
  - `app_version.dart`: constantes centrales de version (`0.0.4+4`).
  - `settings_page.dart`: visualizacion de version sincronizada.
  - `pubspec.yaml`: version oficial elevada a `0.0.4+4`.
- Regla no-monolitos: 100% cumplida (<250 lineas por archivo).
- Pruebas: 100% de tests aprobados (`flutter test`) y 0 advertencias en `flutter analyze`.

## [0.0.3+3] - 2026-10-12 — VIS-C (Boton de Cuenta Estilo Google, Pestana de Ajustes y Remocion de Subidas)
- Cambio: Integracion de boton circular de cuenta estilo Google en AppBar con modal inferior de detalles, creacion del modulo y pantalla de Ajustes (preferencias de lectura, outbox/sync 5s, simulacion offline), y retiro de la pestana de Subidas de la barra principal.
- Modulos y componentes intervenidos:
  - `google_account_avatar_button.dart`: avatar circular (36px, borde #DDD6FE) con soporte de iniciales y splash interactivo.
  - `google_account_sheet.dart`: modal bottom sheet estilo Google Account con rol, punto de control, lista de permisos y logout.
  - `settings/`: modelos (`AppSettings`), controlador (`SettingsController`), pantalla (`SettingsPage`) y tarjeta (`OperatorProfileCard`).
  - `app_shell.dart`: navegacion con pestana de Ajustes en lugar de Subidas e integracion del avatar en AppBar.
- Regla no-monolitos: 100% de archivos <250 lineas y funciones <40 lineas.
- Pruebas: 100% aprobadas con `flutter test` y 0 advertencias en `flutter analyze`.

## [0.0.2+2] - 2026-10-12 — VIS-B (Adaptabilidad e Interfaces Responsivas)
- Cambio: Correccion integral de excepciones `RenderFlex overflow` en pantallas compactas y extremas (360px y 320px).
- Modulos y componentes intervenidos:
  - `primary_button.dart` y `secondary_button.dart`: proteccion de texto con `Flexible` y elipsis.
  - `capture_mode_selector.dart`: etiquetas concisas (`NFC Completo` y `QR Parcial`).
  - `app_shell.dart`: badge responsivo de operador (`maxWidth` adaptativo <360px) y titulo flexible. Desacople de `StudentsPage` (<210 lineas).
  - `records_page.dart`: `Expanded` en encabezado y medio de lectura.
  - `status_badge.dart`: restriccion `maxWidth: 135.0` con elipsis interna.
  - `reports_page.dart`: selector con `Wrap`, boton conciso y desacople de `ReportJobCard` (<176 lineas).
  - `uploads_page.dart`: botones apilados con `LayoutBuilder` y desacople de `UploadItemCard` (<201 lineas).
  - `student_detail_page.dart`: desacople de `StudentActionButtons`, `StudentFieldCard` y `ProjectionBadgeBanner` (<208 lineas).
- Regla no-monolitos: El 100% de los archivos de `lib/` ahora se mantiene estrictamente por debajo de 250 lineas.
- Pruebas: Verificado al 100% con `flutter test` (3 tests ejecutados con exito en 360x780 y 320x640) y `flutter analyze` (0 advertencias).

### 2026-10-11 — VIS-A / FUN-1 (Version 0.0.0+1)
- Cambio: Creacion e implementacion completa de la arquitectura y diseno local de la aplicacion en Flutter (Dart) y capa nativa Android (Kotlin), evitando Java y monolitos.
- Modulos implementados: `session` (login con perfiles de operador y roles), `places` (selector de puntos de control), `reading` (coordinador de captura NFC con proyeccion completa y QR con proyeccion parcial restringida), `students` (ficha y edicion autorizada), `records` (registro de ingreso/salida y filtrado por estado), `uploads` (validacion de fotos <2MB y formatos permitidos), `reports` (solicitud asincrona y descarga) y `sync` (simulador de cola outbox y banner de sincronizacion).
- Permisos Android: Declarados `android.permission.NFC`, `android.permission.INTERNET`, `android.permission.CAMERA` y caracteristicas de hardware con `required="false"`.
- Identidad visual: Tokens oficiales `#1D4ED8`, `#DDD6FE` (superficie con texto oscuro), Roboto, controles de 48px y cero emojis segun `BRANDING.md`.
- Estado: Implementado y verificado mediante pruebas de widgets (`flutter test`).
- Repositorio: Vinculado a `https://github.com/Quetzalq4321q/NexID-V2.git` con `.gitignore` oficial completo.

### 2026-10-11 — Inicio Documental
- Cambio: creación de carpeta agent/ con documentos Markdown y entrada AGENTS.md.
- Motivo: reglas claras y carga selectiva de contexto para reducir tokens.
- Estado: implementado y revisado como documentación; no activado en una app.
- Validación: enlaces internos y estructura ZIP comprobados.
- Núcleo/permisos: sin modificaciones. Backup: no aplica, archivos nuevos.

## Formato para cambios futuros
Fecha / motivo / módulo y archivos / antes-después / estado real / pruebas y resultado / aprobación si aplica / backup y hash si aplica / reversión.

### 2026-10-11 — Ampliación documental (SIN_VERSION)
- Incorporados uso multiadaptativo, servidor modular, consultas frecuentes, archivos/TXT y reportes en background.
- Opciones de servidor admitidas: Node.js, Python y PHP; elección pendiente.
- Propuesta inicial de etiqueta combinada reemplazada por la aclaración del usuario: versión numérica normal desde 0.0.0. Letras/números se conservan solo como IDs del historial.
- Estado: documentación implementada, sin ejecución de app ni servidor.

### 2026-10-11 — DOC: precisión del versionado y recuperación
- Problema: la propuesta inicial confundía IDs de cambios con versión de la app.
- Decisión: MAJOR.MINOR.PATCH desde 0.0.0; IDs VIS/FUN separados.
- Antes: propuesta de etiqueta alfanumérica. Después: versión numérica, registro de lógica antes/después, razonamiento, diff, pruebas y reversión.
- Archivos: 01_REGLAS.md, 10_VERSIONADO.md, 11_PLANTILLA_CAMBIO.md, índice y estado.
- Estado: documentación implementada. No hubo cambios a código de app, servidor o datos.
- Referencia Git: no aplica, kit nuevo sin repositorio; no se inventaron commits.
- Recuperación: conservar esta aclaración del usuario; cualquier cambio futuro del contrato requiere su aprobación.

### 2026-10-11 — DOC-NEXLABS-001
- Incorporado producto Android NFC/QR, alumnos, lugares, registros, fotos, API, BD, seguridad de uploads y servidor exclusivo en subdominio Nexlabs.
- Política propuesta: ficha NFC completa autorizada; QR con proyección parcial en servidor. Lectura no crea evento por defecto.
- Estado: kit documental verificado; app, base y servidor no implementados ni desplegados.
- Motivo, antes/después, backup, diff y reversión: [detalle](changes/DOC-NEXLABS-001.md).
- Tipo NFC, evento, roles/campos, capacidades PHP/BD y subdominio: pendientes.

### 2026-10-11 — DOC-NEXLABS-001, continuidad confirmada
- PHP elegido por el usuario; SQLite local como respaldo ante latencia/fallo/saturación.
- Definida cola de dos pasadas: 5 segundos entre envíos, rechazados recuperables al final, segundo fallo a revisión manual, mismo ID idempotente.
- Antes: stack/cola no definidos. Después: contrato PHP/SQLite, estados durables, separación aceptado/confirmado y conciliación por operación.
- Archivos: 20_SQLITE_LOCAL.md, 21_COLA_5_SEGUNDOS.md, 22_SERVIDOR_PHP.md y documentos relacionados.
- Estado: documentación verificada; sin código ejecutado ni versión de app activada.
- Backup/diff/reversión: changes/DOC-NEXLABS-001.md.

### 2026-10-11 — DOC-NEXLABS-001, MariaDB y subconjunto local
- MariaDB confirmada como base central; SQLite local limitada y suficiente para datos conocidos/visualización más pendientes.
- Añadidos campos mínimos propuestos, precarga selectiva, fotos privadas, cursor consistente, frescura y separación NFC/QR también en caché.
- Estado: documentación implementada, sin migraciones, datos reales o servicios activados.
- Referencia y recuperación: changes/DOC-NEXLABS-001.md y diff de la entrega.
