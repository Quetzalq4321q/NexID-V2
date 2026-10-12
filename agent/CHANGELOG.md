# Changelog

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
