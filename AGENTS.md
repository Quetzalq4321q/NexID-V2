# Entrada del agente

Antes de trabajar lee agent/00_INDEX.md y agent/01_REGLAS.md. Antes de modificar cualquier archivo lee agent/05_CAMBIOS.md. Después carga solo los documentos indicados para tu tarea. Al retomar lee agent/ESTADO.md y el historial relevante. Estas reglas aplican a todo el proyecto. No modifiques las reglas para eludirlas; cambios a este contrato requieren aprobación del usuario.

---

## Arquitectura General y Organizacion de Modulos (`v0.0.6+6`)

El proyecto **NexID** sigue una arquitectura modular estricta por funcionalidad (feature-first) con separacion entre `domain`, `data` y `presentation`, cumpliendo la regla anti-monolitos (`< 250 lineas` por archivo y `< 40 lineas` por funcion) y cero emojis:

- `lib/app/`: Composicion raiz (`app.dart`), contenedor de navegacion adaptable (`app_shell.dart`), inyeccion de dependencias (`app_dependencies.dart`) y temas independientes (`app_theme.dart`).
- `lib/core/`:
  - `constants/`: Dimensiones (`app_dimensions.dart`), tipografia Roboto (`app_typography.dart`), paleta base (`app_colors.dart`) y versionado (`app_version.dart`).
  - `theme/`: Tokens semanticos reactivos (`nexid_palette.dart`) mediante `ThemeExtension<NexIdPalette>`.
  - `platform/`: Puente nativo Kotlin (`hardware_bridge.dart`) para lector NFC y camara QR.
  - `responsive/`: Puntos de corte (`responsive_layout.dart`).
- `lib/shared/widgets/`: Componentes reutilizables (`PrimaryButton`, `SecondaryButton`, `StatusBadge`, `AvatarPlaceholder`, `EmptyState`) y sistema de Skeleton Loading (`skeleton/shimmer_skeleton.dart`, `skeleton/module_skeletons.dart`).
- `lib/features/`:
  - `session/`: Autenticacion de operadores, roles y modal estilo cuenta Google.
  - `places/`: Seleccion de puntos de control.
  - `reading/`: Coordinacion de lectura fisica NFC (proyeccion completa) y QR (proyeccion parcial).
  - `students/`: Padron de alumnos, KPIs, filtros y expediente integral por pestañas (`Personal`, `Academico`, `Seguimiento`).
  - `records/`: Historial auditable con busqueda avanzada, desplegable unificado, paginacion progresiva y hoja modal de auditoria (`RecordDetailSheet`).
  - `reports/`: Trabajos de reporte y vista previa de documentos PDF en formato A4 (`PdfPreviewPage`, `PdfA4SheetWidget`).
  - `settings/`: Preferencias operativas, deteccion automatica del tema del SO y controles de accesibilidad WCAG 2.2.
  - `sync/`: Motor local de sincronizacion en dos pasadas con intervalos de 5 segundos.

---

## Sistema de Accesibilidad (WCAG 2.2) y Gestion de Temas

1. **Deteccion y Modos (`AppThemePreference`)**:
   - `system` (`Automatico`): Detecta `MediaQuery.platformBrightnessOf(context)` en tiempo real.
   - `light` (`Claro`): Activa `AppTheme.light(highContrast: ...)`.
   - `dark` (`Oscuro`): Activa `AppTheme.dark(highContrast: ...)`.
2. **Independencia entre Modo Claro y Modo Oscuro**:
   - **Prohibido** usar colores estaticos (`Colors.white`, `Colors.black`, `AppColors.background`) directamente en las vistas de la aplicacion.
   - **Obligatorio** consumir `final NexIdPalette palette = NexIdPalette.of(context);` para fondos (`palette.background`), tarjetas (`palette.surface`), modales (`palette.surfaceElevated`), bordes (`palette.border`), textos (`palette.textPrimary`, `palette.textSecondary`) y estados semanticos (`palette.success`, `palette.warning`, `palette.error`).
   - Excepcion unica: El lienzo de hoja impresa A4 (`PdfA4SheetWidget`) conserva fondo de papel blanco para representar fielmente el documento fisico antes de imprimir.
3. **Controles de Accesibilidad (`SettingsController`)**:
   - Escala tipografica (`90%`, `100%`, `115%`, `130%`) inyectada en `MediaQuery.textScaler`.
   - Modo de Alto Contraste (`WCAG 2.2 AAA`) con bordes reforzados y contraste incrementado.
   - Reduccion de movimiento (`reduceMotion`) que desactiva animaciones decorativas y reemplaza el barrido shimmer por bloques estaticos.
   - Compatibilidad con lectores de pantalla mediante nodos `Semantics` y `Tooltip`.

---

## Uso del Sistema Global de Skeleton Loading

- Toda pantalla conectada a datos (`StudentsPage`, `RecordsPage`) debe envolver su listado en `DataStateBoundary` (`lib/shared/widgets/skeleton/shimmer_skeleton.dart`).
- Nunca mostrar pantallas vacias o spinners aislados en la primera carga: utilizar el skeleton estructural especifico del modulo (`StudentListSkeleton`, `RecordListSkeleton`, `KpiSummarySkeleton` en `lib/shared/widgets/skeleton/module_skeletons.dart`).
- Cuando existen datos en cache local (`hasCachedData == true`), mantener los datos visibles durante la recarga y mostrar un indicador lineal superior sin bloquear la interaccion.

---

## Lineamientos de Animaciones y Microinteracciones

- Utilizar duraciones cortas y naturales (`180ms` a `220ms`, `Curves.easeOutCubic`).
- Consultar siempre `MediaQuery.disableAnimationsOf(context)` o `settingsController.reduceMotion` antes de ejecutar transiciones (`AnimatedSwitcher`, `ShimmerBox`).

---

## Modulos de Alumnos, Registros y Flujo de Generacion PDF (A4)

- **Alumnos (`features/students/`)**: El modelo `Student` preserva los campos minimos de `agent/23_CACHE_USABLE.md` y separa las secciones extendidas de demostracion (`isDemoExtendedData = true`) en tres pestañas (`StudentPersonalTab`, `StudentAcademicTab`, `StudentFollowUpTab`).
- **Registros (`features/records/`)**: Cada `EventRecord` conserva `idempotencyKey`, `operatorName`, `lastModifiedAt`, `relatedInfo` y `changeHistory`. El listado aplica paginacion progresiva (`pageSize = 6`) para proteger la memoria.
- **Vista Previa PDF A4 (`features/reports/`)**: `PdfPreviewPage` renderiza la maqueta institucional A4 (`PdfA4SheetWidget` y `PdfA4SectionsWidget`) para *Ficha Institucional de Alumno* y *Reporte General de Registros*.

---

## Restricciones de Seguridad, Base de Datos y Datos Sensibles

- No modificar el esquema SQLite ni el backend PHP/MariaDB sin validacion previa de relaciones.
- Respetar la politica de proyeccion (`agent/13_NFC_QR.md`): NFC habilita ficha completa autorizada; QR restringe datos sensibles como el DNI.
- No exponer datos personales de estudiantes en `debugPrint`, logs de consola ni reportes no autorizados.
