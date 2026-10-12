# Entrada del agente

Antes de trabajar lee `agent/00_INDEX.md`, `agent/01_REGLAS.md` y `docs/PROGRESS.md`. Antes de modificar cualquier archivo lee `agent/05_CAMBIOS.md` y `docs/DECISIONS.md`. Después carga solo los documentos indicados para tu tarea. Al finalizar cualquier cambio relevante, actualiza `docs/PROGRESS.md`, `agent/ESTADO.md` y `CHANGELOG.md`. Estas reglas aplican a todo el proyecto. No modifiques las reglas para eludirlas; cambios a este contrato requieren aprobación del usuario.

---

## Orden General de Prioridades Permanentes

1. **PRIORIDAD 0:** Estabilidad, detección real de hardware Android, adaptación inteligente automática y optimización extrema para dispositivos económicos de 2–4 GB de RAM (`docs/missions/PRIORITY_0_PERFORMANCE.md` y `docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`).
2. **PRIORIDAD 1:** Corrección de errores funcionales, especialmente lectura NFC, registros y persistencia local (`docs/missions/NFC_VALIDATION.md`).
3. **PRIORIDAD 2:** Interfaces responsivas (320 px a tablet) y eliminación de deformaciones (`docs/missions/UI_RESPONSIVENESS.md`).
4. **PRIORIDAD 3:** Independencia de los temas claro y oscuro, accesibilidad WCAG 2.2 y paleta institucional (`docs/missions/THEMES_ACCESSIBILITY.md`).
5. **PRIORIDAD 4:** Optimización de alumnos, matrícula, fotografías y presentación de registros (`docs/missions/STUDENTS_RECORDS.md`).
6. **PRIORIDAD 5:** Skeletons ligeros, caché LRU, cargas progresivas y microinteracciones subordinadas a la Prioridad 0.
7. **PRIORIDAD 6:** Conservación y optimización asíncrona de reportes PDF A4 y funcionalidades adicionales (`docs/missions/REPORTS_PDF.md`).

---

## PRIORIDAD 0 — Compatibilidad y rendimiento en dispositivos de gama baja

Esta prioridad está por encima de cualquier cambio estético, animación o ampliación de información:

1. **Detección Nativa de Hardware y Adaptación Automática (`DeviceCapabilitiesManager.kt` + `lib/core/performance/device_performance_tier.dart`)**:
   - Diseñado pensando primero en un celular Android económico con **2 GB de RAM**, procesador lento, almacenamiento eMMC lento y red inestable (Samsung Galaxy A13, Samsung Galaxy A14, Xiaomi Redmi 15C y equivalentes).
   - En el arranque (`SettingsController.detectAndAdaptHardware()`), consulta directamente a Android (`ActivityManager`, `PowerManager`, `StatFs`, `ConnectivityManager`, `Build`) y selecciona automáticamente el nivel adaptativo (`Rendimiento ligero`, `Rendimiento equilibrado`, `Rendimiento completo`) con `isAutoPerformance = true` por defecto.
   - El usuario normal no debe configurar manualmente la RAM de su teléfono; la selección manual (`ultraLowEnd2Gb`, `lowEnd3Gb`, `budgetMid4Gb`, `adverseConditions`) está restringida a **Configuración avanzada** con permisos reales de Administrador (`SessionController.canAccessAdvancedSettings`) y jamás falsifica los datos reales de hardware.
2. **Reglas de Consumo de Memoria (`DeviceMemoryGuard`)**:
   - `NexIdApp` observa `didHaveMemoryPressure()` y `didChangeAppLifecycleState(AppLifecycleState.paused / detached)` para liberar inmediatamente `PaintingBinding.instance.imageCache`, cachés temporales de detalle y degradar automáticamente el perfil ante presión de memoria.
   - **Prohibido** precargar toda la base de datos o todas las fotografías de alumnos en memoria.
   - Todos los `ChangeNotifier`, `Timer` de debounce y listeners nativos deben liberarse en `dispose()`.
3. **Estrategias de Caché (`lib/core/performance/bounded_lru_cache.dart`)**:
   - `BoundedLruCache` impone límite estricto de entradas (`maxEntries`), expiración por `TTL` y deduplicación de peticiones en vuelo (`putIfAbsentAsync`).
   - **Separación estricta**: La limpieza de caché temporal jamás borra ni altera los registros pendientes de sincronización en SQLite (`outbox` / `RecordsRepository`).
4. **Carga Progresiva de Información**:
   - El listado de alumnos (`StudentsRepository.getStudents()`) carga únicamente los campos esenciales de resumen.
   - Los cursos, documentos, observaciones e historial (`hydrateStudentDetail`) se cargan bajo demanda únicamente cuando el usuario abre `StudentFullProfilePage` o `PdfPreviewPage`.
5. **Priorización de Procesos (`lib/core/performance/priority_task_scheduler.dart`)**:
   - `TaskPriority.critical`: Lectura/validación NFC, creación de registros y respuesta táctil inmediata (`runCritical`). Pausa el inicio de tareas de baja prioridad.
   - `TaskPriority.medium`: Carga paginada de listas visibles e hidratación de expediente activo.
   - `TaskPriority.low`: Preparación de reportes pesados ejecutada mediante `Isolate.run` (`runCpuIntensive`) sin bloquear el hilo principal. Nunca usar `sleep` bloqueante.
6. **Restricciones de Animaciones e Interfaz**:
   - Cuando `effectiveReduceMotion` está activo (automático en perfiles de 2–3 GB o Modo de Rendimiento Reducido), `ShimmerBox` renderiza bloques estáticos sin `AnimationController` y `AppShell` conmuta vistas sin transiciones costosas.
   - Prohibido usar desenfoques (`BackdropFilter`), transparencias anidadas o sombras pesadas.
7. **Criterios de Optimización para Flutter**:
   - Listas grandes deben usar `ListView.separated` / `ListView.builder` con `addAutomaticKeepAlives: false` y `addRepaintBoundaries: true`.
   - Búsquedas de texto deben usar debounce (`setSearchQueryDebounced`).
   - Lienzos complejos como `PdfA4SheetWidget` deben aislarse dentro de `RepaintBoundary`.
8. **Pruebas Obligatorias antes de Aprobar Cambios**:
   - Ejecutar `flutter analyze` (`0` incidencias) y `flutter test` verificando `test/widget_test.dart`, `test/performance_low_end_test.dart` y `test/device_capabilities_settings_test.dart`.
   - Verificar que el 100% de los archivos `.dart` tengan `< 250 líneas` y cada función `< 40 líneas`.

---

## Arquitectura General y Mapa de Documentación (`v0.0.8+8`)

- **Código fuente (`lib/`)**:
  - `lib/app/`: Composición raíz (`app.dart`), contenedor adaptable (`app_shell.dart`), inyección (`app_dependencies.dart`) y temas (`app_theme.dart`).
  - `lib/core/`: Constantes (`constants/`), paleta reactiva (`theme/nexid_palette.dart`), puente nativo Kotlin y telemetría (`platform/hardware_bridge.dart`, `device_capabilities_models.dart`), puntos de corte (`responsive/`) y motor de rendimiento de gama baja (`performance/`).
  - `lib/shared/widgets/`: Componentes reutilizables y sistema ligero de Skeleton Loading (`skeleton/`).
  - `lib/features/`: Módulos desacoplados (`session`, `places`, `reading`, `students`, `records`, `reports`, `settings`, `sync`).
- **Memoria Técnica y Misiones (`docs/` y `agent/`)**:
  - Índice de reglas base y contratos de servidor/SQLite: [`agent/00_INDEX.md`](file:///c:/Users/User/StudioProjects/NexID/agent/00_INDEX.md) y [`agent/ESTADO.md`](file:///c:/Users/User/StudioProjects/NexID/agent/ESTADO.md).
  - Estado de avance, pruebas y guía para el siguiente agente: [`docs/PROGRESS.md`](file:///c:/Users/User/StudioProjects/NexID/docs/PROGRESS.md).
  - Decisiones arquitectónicas consolidadas: [`docs/DECISIONS.md`](file:///c:/Users/User/StudioProjects/NexID/docs/DECISIONS.md).
  - Misiones específicas:
    - [`docs/missions/PRIORITY_0_PERFORMANCE.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/PRIORITY_0_PERFORMANCE.md)
    - [`docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/DEVICE_CAPABILITIES_SETTINGS.md)
    - [`docs/missions/NFC_VALIDATION.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/NFC_VALIDATION.md)
    - [`docs/missions/UI_RESPONSIVENESS.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/UI_RESPONSIVENESS.md)
    - [`docs/missions/THEMES_ACCESSIBILITY.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/THEMES_ACCESSIBILITY.md)
    - [`docs/missions/STUDENTS_RECORDS.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/STUDENTS_RECORDS.md)
    - [`docs/missions/REPORTS_PDF.md`](file:///c:/Users/User/StudioProjects/NexID/docs/missions/REPORTS_PDF.md)
