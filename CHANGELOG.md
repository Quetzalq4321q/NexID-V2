# Changelog Global - NexID

Todas las modificaciones notables de este proyecto están documentadas en este archivo, siguiendo el formato estándar de trazabilidad estipulado en `agent/10_VERSIONADO.md`, `agent/11_PLANTILLA_CAMBIO.md` y `agent/05_CAMBIOS.md`.

El proyecto utiliza versionado semántico formal (`MAJOR.MINOR.PATCH+BUILD`) a partir de la versión base `0.0.0+1`.

---

## [Unreleased]

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
