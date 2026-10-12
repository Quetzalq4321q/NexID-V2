# Changelog Global - NexID

Todas las modificaciones notables de este proyecto están documentadas en este archivo, siguiendo el formato estándar de trazabilidad estipulado en `agent/10_VERSIONADO.md`, `agent/11_PLANTILLA_CAMBIO.md` y `agent/05_CAMBIOS.md`.

El proyecto utiliza versionado semántico formal (`MAJOR.MINOR.PATCH+BUILD`) a partir de la versión base `0.0.0+1`.

---

## [0.0.9+9] - 2026-10-12

### [VIS-SETTINGS-FINAL] Diseño Visual Definitivo de Configuración, Tarjeta de Optimización Automática y 8 Categorías con Subpantallas Dedicadas
- **Fecha:** 2026-10-12
- **Categoría:** Interfaz Visual (UI/UX) / Configuración / Detección de Hardware (Prioridad 0) / Accesibilidad (Prioridad 3)
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Implementar en Flutter la distribución visual definitiva del apartado **Configuración** conectada con las funcionalidades existentes: encabezado compacto con flecha de retorno, título «Configuración» e icono de ajustes alineado; barra de búsqueda «Buscar un ajuste...»; tarjeta destacada **Optimización del dispositivo** (`Estado: Automática`, conectada a la detección real sin mostrar confirmación si la detección no ha concluido); y lista vertical ordenada de 8 categorías con subpantallas dedicadas.
  - Utilizar tonos neutros y variantes azules (sin acentos morados) y mantener la **Configuración avanzada** oculta de la lista principal y restringida por permisos de Administrador.
- **Archivos creados:**
  - `lib/features/settings/presentation/widgets/device_optimization_banner.dart`
- **Archivos modificados:**
  - `lib/app/app_shell.dart`, `lib/core/constants/app_colors.dart`, `lib/core/constants/app_version.dart`, `lib/core/platform/hardware_bridge.dart`, `lib/core/theme/nexid_palette.dart`, `pubspec.yaml`
  - `lib/features/settings/domain/settings_search_catalog.dart`, `lib/features/settings/presentation/controllers/settings_controller.dart`, `lib/features/settings/presentation/pages/settings_page.dart`, `lib/features/settings/presentation/widgets/settings_system_sections.dart`
  - `AGENTS.md`, `docs/PROGRESS.md`, `docs/DECISIONS.md`, `docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`, `docs/missions/THEMES_ACCESSIBILITY.md`, `agent/ESTADO.md`, `agent/CHANGELOG.md`, `test/widget_test.dart`, `test/device_capabilities_settings_test.dart`

---

## [0.0.8+8] - 2026-10-12

### [HW-AUTO-SETTINGS] Detección Real de Hardware Android, Configuración Inteligente Automática, Buscador de Ajustes y Configuración Avanzada Restringida
- **Fecha:** 2026-10-12
- **Categoría:** Hardware Nativo (Kotlin) / Rendimiento Adaptativo (Prioridad 0) / Ajustes / Seguridad por Roles
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Consultar directamente la información real de hardware y estado del sistema operativo Android (`ActivityManager`, `PackageManager`, `PowerManager`, `StatFs`, `BatteryManager`, `ConnectivityManager`, `Build`) sin inventar cifras ni depender del nombre comercial del teléfono.
  - Implementar adaptación automática e inteligente de rendimiento por defecto (`Rendimiento ligero`, `Rendimiento equilibrado`, `Rendimiento completo`) sin que el usuario normal tenga que elegir manualmente entre 2 GB, 3 GB o 4 GB de RAM.
  - Reorganizar completamente el apartado de Ajustes en categorías claras con un buscador superior instantáneo y aislar las opciones manuales/técnicas en **Configuración avanzada** protegida por permisos reales de Administrador.
- **Archivos creados:**
  - `android/app/src/main/kotlin/com/nexlabs/nexid/DeviceCapabilitiesManager.kt`
  - `lib/core/platform/device_capabilities_models.dart`
  - `lib/features/settings/domain/settings_search_catalog.dart`
  - `lib/features/settings/presentation/widgets/settings_system_sections.dart`
  - `lib/features/settings/presentation/widgets/advanced_settings_card.dart`
  - `docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`
  - `test/device_capabilities_settings_test.dart`
- **Archivos modificados:**
  - `android/app/src/main/AndroidManifest.xml`, `android/app/src/main/kotlin/com/nexlabs/nexid/MainActivity.kt`
  - `lib/core/platform/hardware_bridge.dart`, `lib/core/performance/device_performance_tier.dart`, `lib/core/constants/app_version.dart`, `pubspec.yaml`, `lib/app/app.dart`
  - `lib/features/session/domain/session_models.dart`, `lib/features/session/presentation/controllers/session_controller.dart`
  - `lib/features/settings/domain/settings_models.dart`, `lib/features/settings/presentation/controllers/settings_controller.dart`, `lib/features/settings/presentation/pages/settings_page.dart`, `lib/features/settings/presentation/widgets/low_end_performance_card.dart`, `lib/features/settings/presentation/widgets/theme_appearance_card.dart`
  - `AGENTS.md`, `docs/PROGRESS.md`, `docs/DECISIONS.md`, `docs/missions/PRIORITY_0_PERFORMANCE.md`, `agent/00_INDEX.md`, `agent/ESTADO.md`, `agent/CHANGELOG.md`, `test/widget_test.dart`

---

## [0.0.7+7] - 2026-10-12

### [PERF-0] PRIORIDAD 0 — Optimización Extrema para Dispositivos Android de Gama Baja (2–4 GB RAM) y Memoria Técnica Persistente entre Agentes
- **Fecha:** 2026-10-12
- **Categoría:** Rendimiento / Memoria RAM / Concurrencia / NFC Crítico / Documentación de Continuidad
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Priorizar por encima de cualquier cambio estético la fluidez y estabilidad en celulares Android económicos (Samsung Galaxy A13, Galaxy A14, Redmi 15C, 2 GB / 3 GB / 4 GB de RAM, CPU lenta y red inestable).
  - Implementar simulación de dispositivos limitados, gestión inteligente de RAM (`ImageCache` y caché LRU acotada), liberación automática en segundo plano o baja memoria sin borrar la cola SQLite, priorización de procesos (NFC en prioridad crítica, PDF en Isolate de baja prioridad), hidratación diferida de fichas de alumnos, debounce en búsquedas y suite de 12 escenarios de prueba.
  - Integrar la memoria técnica persistente en `AGENTS.md`, `agent/` y `docs/missions/` para continuidad automática entre agentes.
- **Archivos creados:**
  - `lib/core/performance/device_performance_tier.dart`
  - `lib/core/performance/priority_task_scheduler.dart`
  - `lib/core/performance/bounded_lru_cache.dart`
  - `lib/features/settings/presentation/widgets/low_end_performance_card.dart`
  - `test/performance_low_end_test.dart`
  - `docs/DECISIONS.md`, `docs/PROGRESS.md`
  - `docs/missions/PRIORITY_0_PERFORMANCE.md`, `docs/missions/UI_RESPONSIVENESS.md`, `docs/missions/THEMES_ACCESSIBILITY.md`, `docs/missions/NFC_VALIDATION.md`, `docs/missions/STUDENTS_RECORDS.md`, `docs/missions/REPORTS_PDF.md`
- **Archivos modificados:**
  - `lib/app/app.dart`, `lib/core/constants/app_version.dart`, `pubspec.yaml`
  - `lib/features/settings/domain/settings_models.dart`, `lib/features/settings/presentation/controllers/settings_controller.dart`, `lib/features/settings/presentation/pages/settings_page.dart`
  - `lib/features/students/data/students_repository.dart`, `lib/features/students/presentation/controllers/students_controller.dart`, `lib/features/students/presentation/pages/students_page.dart`, `lib/features/students/presentation/pages/student_full_profile_page.dart`
  - `lib/features/reading/presentation/controllers/reading_controller.dart`
  - `lib/features/records/presentation/controllers/records_controller.dart`, `lib/features/records/presentation/pages/records_page.dart`
  - `lib/features/reports/presentation/controllers/reports_controller.dart`, `lib/features/reports/presentation/pages/pdf_preview_page.dart`
  - `AGENTS.md`, `agent/00_INDEX.md`, `agent/ESTADO.md`, `agent/CHANGELOG.md`, `test/widget_test.dart`

---

## [0.0.6+6] - 2026-10-12

### [VIS-F / FUN-3] Sistema de Accesibilidad WCAG 2.2, Temas Independientes Claro/Oscuro, Skeleton Loading, Expediente de Alumnos, Auditoria de Registros y Vista Previa PDF A4
- **Fecha:** 2026-10-12
- **Categoría:** Accesibilidad / UI-UX / Temas / Skeletons / Alumnos / Registros / PDF A4
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Implementar un apartado de accesibilidad y apariencia en Configuración capaz de detectar automáticamente el tema del SO (`Claro`, `Oscuro`, `Automático`) con independencia total entre modo claro y modo oscuro, escala de fuente, alto contraste, reducción de animaciones y soporte para lector de pantalla (WCAG 2.2).
  - Integrar un sistema global de Skeleton Loading adaptado a cada módulo con estados de carga, caché, vacío y error con reintento.
  - Ampliar el módulo de alumnos con expediente por pestañas (datos personales, académicos, cursos, asistencia, observaciones, documentos y auditoría con datos de demostración identificados) y el módulo de registros con KPIs, búsqueda, paginación progresiva e historial de cambios.
  - Desarrollar una vista previa interactiva en formato A4 para documentos PDF (Ficha de Alumno y Reporte de Registros) y actualizar `AGENTS.md`.

- **Archivos creados:**
  - `lib/core/theme/nexid_palette.dart`
  - `lib/features/settings/presentation/widgets/theme_appearance_card.dart`
  - `lib/features/settings/presentation/widgets/accessibility_controls_card.dart`
  - `lib/shared/widgets/skeleton/shimmer_skeleton.dart`
  - `lib/shared/widgets/skeleton/module_skeletons.dart`
  - `lib/features/students/presentation/pages/student_full_profile_page.dart`
  - `lib/features/students/presentation/widgets/student_profile_tabs.dart`
  - `lib/features/records/presentation/widgets/record_detail_sheet.dart`
  - `lib/features/reports/presentation/pages/pdf_preview_page.dart`
  - `lib/features/reports/presentation/widgets/pdf_a4_sheet_widget.dart`
  - `lib/features/reports/presentation/widgets/pdf_a4_sections_widget.dart`
  - `agent/24_ACCESIBILIDAD_Y_TEMAS.md`

- **Archivos modificados:**
  - `lib/app/app.dart`, `lib/app/app_theme.dart`, `lib/app/app_shell.dart`
  - `lib/features/settings/domain/settings_models.dart`, `lib/features/settings/presentation/controllers/settings_controller.dart`, `lib/features/settings/presentation/pages/settings_page.dart`
  - `lib/features/students/domain/student_models.dart`, `lib/features/students/data/students_repository.dart`, `lib/features/students/presentation/controllers/students_controller.dart`, `lib/features/students/presentation/pages/students_page.dart`
  - `lib/features/records/domain/record_models.dart`, `lib/features/records/data/records_repository.dart`, `lib/features/records/presentation/controllers/records_controller.dart`, `lib/features/records/presentation/pages/records_page.dart`
  - `lib/features/reports/presentation/pages/reports_page.dart`, `lib/features/reports/presentation/widgets/report_job_card.dart`
  - `lib/core/constants/app_version.dart`, `pubspec.yaml`, `AGENTS.md`, `test/widget_test.dart`

---

## [0.0.5+5] - 2026-10-12

### [FUN-2 / VIS-E] Funcionalidad Nativa Completa de Lectura NFC, Escaneo QR con Permisos en Tiempo de Ejecucion y AndroidManifest.xml
- **Fecha:** 2026-10-12
- **Categoría:** Hardware / Android Nativo (Kotlin) / Permisos / Lectura NFC y QR
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Otorgar funcionalidad completa para leer tarjetas físicas NFC y escanear códigos QR solicitando permisos en tiempo de ejecución, modificando y completando la configuración en `AndroidManifest.xml` y XML de recursos Android.

- **Razonamiento y Solución:**
  - Se amplió `AndroidManifest.xml` con permisos explícitos (`NFC`, `CAMERA`, `VIBRATE`, `INTERNET`), declaración de características de hardware opcionales (`android.hardware.nfc`, `nfc.hce`, `camera`, `camera.autofocus` con `required="false"`), filtros de intent (`NDEF_DISCOVERED`, `TECH_DISCOVERED`, `TAG_DISCOVERED`) y metadatos de Google Code Scanner (`com.google.mlkit.vision.DEPENDENCIES` -> `barcode_ui`).
  - Se creó `android/app/src/main/res/xml/nfc_tech_filter.xml` soportando todas las tecnologías estándar de tarjetas (`NfcA`, `NfcB`, `NfcF`, `NfcV`, `IsoDep`, `Ndef`, `NdefFormatable`, `MifareClassic`, `MifareUltralight`).
  - Se implementó en **100% Kotlin** (cero Java) el gestor `NfcHardwareManager.kt`, que activa `NfcAdapter.enableReaderMode`, intercepta intents NFC, decodifica registros NDEF (texto UTF-8/UTF-16) o extrae el UID físico hexadecimal de la tarjeta, y ofrece apertura directa de los ajustes NFC de Android (`Settings.ACTION_NFC_SETTINGS`).
  - Se implementó en **Kotlin** el gestor `CameraQrManager.kt`, que verifica y solicita en tiempo de ejecución el permiso `android.permission.CAMERA` (`requestPermissions`), maneja `onRequestPermissionsResult` distinguiendo denegación simple o bloqueo permanente, abre los ajustes de permisos de la aplicación (`ACTION_APPLICATION_DETAILS_SETTINGS`) y ejecuta el escáner óptico nativo QR con auto-zoom (`GmsBarcodeScanning`).
  - Se creó el puente `HardwareBridge` en Dart (`lib/core/platform/hardware_bridge.dart`) y el widget desacoplado `ScannerStatusCard` (`lib/features/reading/presentation/widgets/scanner_status_card.dart`), integrados en `ReadingController` y `ReadingPage`.
  - Se incrementó la versión interna del proyecto a `v0.0.5+5`.

- **Archivos creados:**
  - `android/app/src/main/res/xml/nfc_tech_filter.xml`: Lista de tecnologías NFC soportadas.
  - `android/app/src/main/kotlin/com/nexlabs/nexid/NfcHardwareManager.kt`: Lector NFC nativo en Kotlin (153 líneas).
  - `android/app/src/main/kotlin/com/nexlabs/nexid/CameraQrManager.kt`: Gestor de permisos de cámara y escáner QR en Kotlin (113 líneas).
  - `lib/core/platform/hardware_bridge.dart`: Puente MethodChannel en Dart (166 líneas).
  - `lib/features/reading/presentation/widgets/scanner_status_card.dart`: Tarjeta de estado de hardware y controles de permisos (204 líneas).

- **Archivos modificados:**
  - `android/app/src/main/AndroidManifest.xml`: Permisos, features e intent-filters NFC/QR.
  - `android/app/build.gradle.kts`: Dependencia `play-services-code-scanner:16.1.0`.
  - `android/app/src/main/kotlin/com/nexlabs/nexid/MainActivity.kt`: Registro del canal `com.nexlabs.nexid/hardware` y ciclo de vida (85 líneas).
  - `lib/features/reading/presentation/controllers/reading_controller.dart`: Coordinación reactiva con hardware real (208 líneas).
  - `lib/features/reading/presentation/pages/reading_page.dart`: Integración con `ScannerStatusCard` (128 líneas).
  - `lib/core/constants/app_version.dart` y `pubspec.yaml`: Versión elevada a `0.0.5+5`.
  - `test/widget_test.dart`: Validación de estado de hardware y versión `v0.0.5`.

---

## [0.0.4+4] - 2026-10-12

### [VIS-D] Desplegable Unificado de Opciones y Filtros en Registros y Actualizacion de Versiones Internas
- **Fecha:** 2026-10-12
- **Categoría:** UI / Filtros / Versionado
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Sustituir la fila horizontal de chips sueltos en la pantalla de Registros por un único desplegable integrado de opciones y filtros, eliminando el diseño tosco anterior.
  - Actualizar formalmente las versiones internas del proyecto (pubspec.yaml, interfaz, constantes y documentación), reconociendo las iteraciones de entrega acumuladas (v0.0.1, v0.0.2, v0.0.3, hasta v0.0.4+4).

- **Razonamiento y Solución:**
  - La fila previa de `ChoiceChip` horizontales (`Todos`, `Pendientes`, `Confirmados`, `En Revision`) obligaba a desplazamiento lateral en pantallas angostas, ocupaba espacio vertical valioso y lucía tosca y fragmentada.
  - Se creó el widget desacoplado `RecordsFilterDropdown` que unifica los criterios de filtro y opciones en un contenedor elegante (`Icons.tune`, desplegable `DropdownButton`, botón de alternancia cronológica con icono e indicador de conteo reactivo `StatusBadge`).
  - Se extendió `RecordsController` con el enum `RecordFilterCriteria` (`all`, `pending`, `confirmed`, `reviewRequired`, `entrada`, `salida`) y ordenación cronológica ascendente/descendente (`sortDescending`), manteniendo compatibilidad total hacia atrás con `statusFilter`.
  - Se creó la clase inmutable `AppVersion` (`lib/core/constants/app_version.dart`) para centralizar la versión técnica `0.0.4+4`, consumida por `SettingsPage`, `pubspec.yaml` y la suite de pruebas.

- **Archivos creados:**
  - `lib/core/constants/app_version.dart`: Centralización de versiones `0.0.4+4`.
  - `lib/features/records/presentation/widgets/records_filter_dropdown.dart`: Componente desplegable de filtros y opciones (107 líneas).

- **Archivos modificados:**
  - `pubspec.yaml`: Versión incrementada a `0.0.4+4`.
  - `lib/features/records/presentation/controllers/records_controller.dart`: Criterios ampliados y ordenación (134 líneas).
  - `lib/features/records/presentation/pages/records_page.dart`: Integración de desplegable y remoción de chips (149 líneas).
  - `lib/features/settings/presentation/pages/settings_page.dart`: Consumo de `AppVersion.label`.
  - `test/widget_test.dart`: Validación del desplegable de registros y verificación de `v0.0.4`.

---

## [0.0.3+3] - 2026-10-12

### [VIS-C] Boton de Cuenta Estilo Google, Pestana de Ajustes y Limpieza de Navegacion
- **Fecha:** 2026-10-12
- **Categoría:** UI / Navegacion / Perfil / Configuracion
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Crear una rama dedicada (`feature/perfil-ajustes-limpieza`) y llevar los cambios validados a `main`.
  - Retirar la pestana "Subidas" de la barra de navegacion (`NavigationBar` y `NavigationRail`), al carecer de sentido logico en la operativa local actual.
  - Reemplazar el nombre/badge estatico del operador en el AppBar por un boton circular interactivo estilo cuenta de Google que abre un modal con el perfil completo del usuario, su rol, punto asignado, permisos y opciones de sesion.
  - Agregar una nueva pestana de "Ajustes" (Configuracion) con preferencias de lectura (NFC/QR, respuesta sonora y vibracion), gestion de sincronizacion y red (simulacion offline, intervalo de cola de 5 segundos), informacion de la compilacion y tarjeta de perfil del operador.

- **Razonamiento y Solucion:**
  - Se diseno el componente `GoogleAccountAvatarButton` para el AppBar con avatar circular de 36px, borde de realce `#DDD6FE`, inicial del usuario y efecto InkWell accesible.
  - Se creo `GoogleAccountSheet` como hoja modal inferior (`showModalBottomSheet`) estilo Google Account con cabecera de perfil, badge de rol, estado del punto asignado, desglose de permisos y atajos a configuracion y cierre de sesion.
  - Se creo el modulo `settings` con modelo reactivo `AppSettings` (`SettingsController` con `ChangeNotifier`), permitiendo alternar medios preferidos, respuesta haptica/sonora y modo offline.
  - Se creo `SettingsPage` y `OperatorProfileCard` con arquitectura `SingleChildScrollView` y tarjetas `Material` para asegurar cero advertencias de renderizado y total responsividad en pantallas compactas (320px).
  - Se actualizo `AppShell` reemplazando el indice 4 con `SettingsPage` y actualizando los destinos de `NavigationBar` y `NavigationRail`.
  - Se mantuvieron todos los archivos estrictamente por debajo de 250 lineas y 0 advertencias de analisis.

- **Archivos creados:**
  - `lib/features/settings/domain/settings_models.dart`: Modelo inmutable de preferencias del terminal.
  - `lib/features/settings/presentation/controllers/settings_controller.dart`: Controlador reactivo de ajustes.
  - `lib/features/session/presentation/widgets/google_account_avatar_button.dart`: Boton circular de avatar estilo Google.
  - `lib/features/session/presentation/widgets/google_account_sheet.dart`: Hoja modal de cuenta de Google.
  - `lib/features/settings/presentation/pages/settings_page.dart`: Pantalla de ajustes y preferencias (215 lineas).
  - `lib/features/settings/presentation/widgets/operator_profile_card.dart`: Tarjeta de perfil para ajustes (89 lineas).

- **Archivos modificados:**
  - `lib/app/app.dart`: Inyeccion del controlador de configuracion.
  - `lib/app/app_dependencies.dart`: Proveedor de dependencias actualizado con `settingsController`.
  - `lib/app/app_shell.dart`: Boton avatar en AppBar y navegacion hacia "Ajustes" (204 lineas).
  - `test/widget_test.dart`: Cobertura completa del boton de cuenta, modal de perfil y pestana de ajustes.

---

## [0.0.2+2] - 2026-10-12

### [VIS-B] Corrección Integral de Desbordamientos Visuales y Adaptabilidad Multi-Pantalla
- **Fecha:** 2026-10-12
- **Categoría:** Visual / Adaptabilidad / Responsive
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Corregir y adaptar todas las interfaces visuales según `/plan` para eliminar excepciones de desbordamiento `RenderFlex overflow` observadas en pruebas reales en dispositivos móviles (360px y 320px).
  - Mantener estricto apego al contrato de diseño (`agent/03_DISENO.md`), adaptabilidad (`agent/08_ADAPTABILIDAD.md`) y no monolitos (archivos <250 líneas, funciones <40 líneas).
  - Preservar la ejecución 100% local sin intervenir en el backend ni en el servidor PHP.

- **Razonamiento y Solución:**
  - Los botones de acción en filas horizontales fijas (`Row`) desbordaban los contenedores en pantallas de menos de 420 px al forzar dos botones con iconos en menos de 160 px de ancho cada uno. Se implementó `LayoutBuilder` apilando verticalmente en pantallas compactas y horizontalmente en tablets/desktop.
  - En tarjetas de historial (`RecordsPage`, `ReportsPage`, `UploadsPage`), los textos de encabezado estaban colocados junto a `StatusBadge` en `Row(mainAxisAlignment: spaceBetween)` sin envolver en `Expanded` con elipsis, lo que desbordaba el ancho de la tarjeta cuando los textos o estados eran extensos (como `'Confirmado por servidor'`).
  - `StatusBadge` ahora incorpora restricción responsiva `maxWidth` (135 px por defecto) y elipsis interna de texto.
  - `PrimaryButton` y `SecondaryButton` protegen sus etiquetas internas con `Flexible(child: Text(..., maxLines: 1, overflow: TextOverflow.ellipsis))`.
  - El selector de formatos de reportes se transformó de `Row` a `Wrap(spacing: 8, runSpacing: 8)`.
  - El AppBar de `AppShell` ahora adapta el ancho del badge del operador según el ancho de pantalla (`maxWidth: isCompact ? (width < 360 ? 75.0 : 135.0) : 220.0`) y envuelve el título en `Flexible` para garantizar cero desbordamientos incluso en dispositivos ultraestrechos de 320 px.
  - Se eliminaron todos los conatos de código monolítico extrayendo componentes dedicados: `StudentsPage` (210 lín en AppShell), `ReportJobCard` (176 lín en ReportsPage), `UploadItemCard` (201 lín en UploadsPage), `StudentActionButtons`, `StudentFieldCard` y `ProjectionBadgeBanner` (208 lín en StudentDetailPage). El 100% de los archivos de `lib/` ahora cumple con el límite de <250 líneas.

- **Lógica anterior:**
  - `Row` rígidos en botones y encabezados sin restricciones de flexión ni elipsis, causando excepciones `RenderFlex overflowed by ... pixels` en anchos reducidos.
- **Lógica nueva:**
  - Interfaces fluidas y adaptables mediante `LayoutBuilder`, `Wrap`, `Expanded`, `Flexible` y `ConstrainedBox`, verificadas con pruebas automáticas sin un solo error de renderizado.

- **Archivos creados:**
  - `lib/features/students/presentation/pages/students_page.dart`: Página dedicada para el directorio de alumnos.
  - `lib/features/students/presentation/widgets/student_action_buttons.dart`: Botones de acción adaptables para registro.
  - `lib/features/students/presentation/widgets/student_field_card.dart`: Tarjeta de campo con flex adaptativo.
  - `lib/features/students/presentation/widgets/projection_badge_banner.dart`: Banner de nivel de proyección de credencial.
  - `lib/features/reports/presentation/widgets/report_job_card.dart`: Tarjeta desacoplada de trabajos de reporte.
  - `lib/features/uploads/presentation/widgets/upload_item_card.dart`: Tarjeta desacoplada de subidas de archivo.

- **Archivos modificados:**
  - `lib/shared/widgets/primary_button.dart`
  - `lib/shared/widgets/secondary_button.dart`
  - `lib/shared/widgets/status_badge.dart`
  - `lib/app/app_shell.dart`
  - `lib/features/reading/presentation/widgets/capture_mode_selector.dart`
  - `lib/features/records/presentation/pages/records_page.dart`
  - `lib/features/reports/presentation/pages/reports_page.dart`
  - `lib/features/students/presentation/pages/student_detail_page.dart`
  - `lib/features/uploads/presentation/pages/uploads_page.dart`
  - `test/widget_test.dart`


---

## [0.0.0+1] - 2026-10-11

### [VIS-A / FUN-1] Arquitectura Modular Inicial, Diseno Local e Integracion de Permisos Google NFC
- **Fecha:** 2026-10-11
- **Versión:** `0.0.0+1`
- **Categoría:** Mixta (Visual / Funcional / Infraestructura Local)
- **Estado:** Implementado y Verificado
- **Solicitud del usuario:**
  - Construir todo el diseño y las interfaces de la aplicación en Flutter (Dart y Kotlin), evitando monolitos y evitando Java.
  - Implementar los permisos oficiales de Google para el uso de hardware NFC.
  - Mantener la ejecución 100% local sin intervenir en el backend PHP ni en el servidor/BD en esta fase.
  - Guiarse estrictamente por las directrices documentadas en `Kit_Agent_Flutter (2)`.
  - Configurar `.gitignore` y subir todos los cambios al repositorio remoto: `https://github.com/Quetzalq4321q/NexID-V2.git`.

- **Razonamiento y Solución:**
  - Se estructuró el código bajo el estándar modular por funcionalidad (`features/<modulo>/`), garantizando que cada archivo cumpla una única responsabilidad, con un promedio inferior a 250 líneas y funciones menores a 40 líneas.
  - Se definieron los tokens visuales planos estipulados en `agent/03_DISENO.md` (Azul `#1D4ED8`, Morado superficie `#DDD6FE` con texto oscuro, fondo blanco, texto `#111827`, Roboto como tipografía única y cero emojis).
  - Se declararon en `AndroidManifest.xml` los permisos `android.permission.NFC`, `android.permission.INTERNET`, `android.permission.CAMERA` y la característica `android.hardware.nfc` con `android:required="false"`, permitiendo compatibilidad con dispositivos sin lector NFC mediante modalidad QR.
  - Se implementó la resolución diferenciada requerida en `agent/13_NFC_QR.md`: NFC proyecta la ficha completa autorizada, mientras que QR aplica proyección parcial restringiendo datos sensibles (como el número de documento).
  - Se implementaron repositorios y controladores locales para simular el ciclo de vida sin servidor: sesión por roles, puntos de control, registros con claves idempotentes, subida de fotos validada (<2 MB) y cola outbox de dos pasadas e intervalos de 5 segundos.

- **Lógica anterior:**
  - Proyecto vacío con plantilla genérica en Java generada por Android Studio (`Main.java`, `NexID.iml`) sin código Flutter ni estructura modular.
- **Lógica nueva:**
  - Arquitectura modular completa en Flutter (Dart/Kotlin), con inyección desacoplada (`AppDependencies`), tema centralizado (`AppTheme`) y 6 pantallas operativas coordinadas:
    1. Acceso y selección de perfiles locales (`LoginPage`).
    2. Coordinador de lectura NFC y QR (`ReadingPage`).
    3. Ficha de alumno con proyecciones autorizadas (`StudentDetailPage`).
    4. Historial de eventos y control de asistencia (`RecordsPage`).
    5. Edición de datos permitidos para roles autorizados (`StudentEditPage`).
    6. Generación y descarga de reportes asíncronos (`ReportsPage`).
    7. Cola de sincronización local y banner persistente (`SyncStatusBanner`).

- **Archivos y componentes creados/modificados:**
  - `android/app/src/main/AndroidManifest.xml`: Declaración de permisos de Google para NFC, cámara y red.
  - `.gitignore`: Configuración completa para proyectos Flutter/Android.
  - `pubspec.yaml`: Versión inicial `0.0.0+1` y descripción oficial.
  - `lib/core/constants/`: `app_colors.dart`, `app_dimensions.dart`, `app_typography.dart`.
  - `lib/core/responsive/`: `responsive_layout.dart`.
  - `lib/shared/widgets/`: `primary_button.dart`, `secondary_button.dart`, `status_badge.dart`, `avatar_placeholder.dart`, `empty_state.dart`.
  - `lib/shared/utils/`: `date_formatter.dart`, `string_validators.dart`.
  - `lib/features/session/`: `domain/session_models.dart`, `data/session_repository.dart`, `presentation/controllers/session_controller.dart`, `presentation/pages/login_page.dart`.
  - `lib/features/places/`: `domain/place_model.dart`, `data/places_repository.dart`, `presentation/controllers/places_controller.dart`, `presentation/widgets/place_selector_dropdown.dart`.
  - `lib/features/reading/`: `domain/credential_models.dart`, `data/reading_repository.dart`, `presentation/controllers/reading_controller.dart`, `presentation/pages/reading_page.dart`, `presentation/widgets/capture_mode_selector.dart`.
  - `lib/features/students/`: `domain/student_models.dart`, `data/students_repository.dart`, `presentation/controllers/students_controller.dart`, `presentation/pages/student_detail_page.dart`, `presentation/pages/student_edit_page.dart`.
  - `lib/features/records/`: `domain/record_models.dart`, `data/records_repository.dart`, `presentation/controllers/records_controller.dart`, `presentation/pages/records_page.dart`.
  - `lib/features/uploads/`: `domain/upload_models.dart`, `data/uploads_repository.dart`, `presentation/controllers/uploads_controller.dart`, `presentation/pages/uploads_page.dart`.
  - `lib/features/reports/`: `domain/report_models.dart`, `data/reports_repository.dart`, `presentation/controllers/reports_controller.dart`, `presentation/pages/reports_page.dart`.
  - `lib/features/sync/`: `domain/sync_models.dart`, `data/sync_repository.dart`, `presentation/controllers/sync_controller.dart`, `presentation/widgets/sync_status_banner.dart`.
  - `lib/app/`: `app.dart`, `app_shell.dart`, `app_dependencies.dart`, `app_theme.dart`.
  - `lib/main.dart`: Punto de entrada mínimo.
  - `README.md`: Documentación completa en español.
  - `BRANDING.md`: Guía de identidad visual, paleta oficial y tokens de diseño.
  - `test/widget_test.dart`: Prueba de arranque inicial y verificación de interfaz.

- **Pruebas ejecutadas:**
  - `flutter test`: Aprobado (100% de pruebas pasadas exitosamente).
  - `dart analyze`: Verificado sin errores de tipado o dependencias faltantes.
- **Referencia Git:**
  - Commit inicial: `52d0154`
  - Rama: `main`
  - Repositorio: `https://github.com/Quetzalq4321q/NexID-V2.git`
- **Reversión:**
  - Al ser el primer commit funcional de la base de código, la reversión implicaría regresar a la plantilla inicial limpia. No existen dependencias con bases de datos ni migraciones en esta etapa.

---

## Historial Documental Previas (Kit Documental Base)

### 2026-10-11 — [DOC-NEXLABS-001] MariaDB y Subconjunto Local
- **Motivo:** Confirmación de MariaDB como base de datos central y definición del alcance de persistencia local en SQLite.
- **Detalle:** Definición en `agent/23_CACHE_USABLE.md` de campos mínimos a almacenar en el dispositivo móvil (alumnos, lugares y registros pendientes), evitando replicar toda la base central.
- **Estado:** Documentación aprobada; sin código de producción ejecutado.

### 2026-10-11 — [DOC-NEXLABS-001] Continuidad Confirmada y Cola Outbox
- **Motivo:** Elección de PHP para el servidor y establecimiento del mecanismo de tolerancia a fallos/latencia.
- **Detalle:** Definición del protocolo de cola de dos pasadas con intervalos mínimos de 5 segundos, reintentos al final de la cola y revisión manual obligatoria tras el segundo fallo, documentado en `agent/20_SQLITE_LOCAL.md` y `agent/21_COLA_5_SEGUNDOS.md`.
- **Estado:** Documentación aprobada.

### 2026-10-11 — [DOC-NEXLABS-001] Especificación Inicial del Producto
- **Motivo:** Definición de requisitos para el sistema Android NFC/QR conectado a un subdominio de `nexlabs.net.pe`.
- **Detalle:** Especificación de lectura NFC de ficha completa y lectura QR de proyección parcial, gestión de fotos, registros de asistencia y prohibición de alterar el sitio principal de Nexlabs.
- **Estado:** Documentación aprobada.

### 2026-10-11 — Precisión del Versionado y Recuperación
- **Motivo:** Clarificación del esquema de versiones del proyecto.
- **Detalle:** Establecimiento del estándar semántico formal `MAJOR.MINOR.PATCH` iniciando en `0.0.0`, y uso de identificadores alfanuméricos (`VIS-x`, `FUN-x`) exclusivamente para el historial de cambios en `agent/10_VERSIONADO.md`.
- **Estado:** Documentación aprobada.
