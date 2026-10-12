# Mision: PRIORIDAD 0 — Optimizacion para Dispositivos de 2 a 4 GB de RAM

## 1. Objetivo Innegociable
Garantizar fluidez, estabilidad y respuesta tactil inmediata en celulares Android economicos (Samsung Galaxy A13, Samsung Galaxy A14, Xiaomi Redmi 15C y equivalentes con 2 GB, 3 GB o 4 GB de RAM, CPU lenta, almacenamiento eMMC lento y red movil intermitente).

## 2. Deteccion Real de Hardware y Adaptacion Automatica (`v0.0.8+8`)
- En el arranque (`SettingsController.detectAndAdaptHardware()`), la app consulta el canal nativo `com.nexlabs.nexid/hardware` (`DeviceCapabilitiesManager.kt`) para obtener RAM total/disponible, umbral `lowMemory`, `isLowRamDevice`, heap maximo del proceso, nucleos/arquitectura CPU, almacenamiento libre, ahorro de bateria, estado termico, conectividad y soporte NFC.
- Por defecto (`isAutoPerformance = true`), `DevicePerformanceProfile.resolveAutomaticProfile()` selecciona automaticamente el nivel interno (`AdaptivePerformanceLevel.lightweight`, `balanced` o `full`) sin que el usuario normal tenga que elegir manualmente la RAM de su telefono.
- La seleccion manual de perfil (`2 GB`, `3 GB`, `4 GB`, `Condiciones adversas`) esta restringida exclusivamente a **Configuracion avanzada** para administradores autorizados (`docs/missions/DEVICE_CAPABILITIES_SETTINGS.md`) y nunca falsifica las metricas reales de hardware reportadas por Android.

## 3. Perfiles de Presupuesto Operativo (`lib/core/performance/device_performance_tier.dart`)
| Perfil (`DevicePerformanceProfile`) | Nivel Adaptativo | RAM Objetivo | Cache Imagenes (`maxImageCacheCount` / `Bytes`) | Fichas Extendidas en RAM (`BoundedLruCache`) | Lote Paginacion (`listPageSize`) | Debounce Busqueda | UI Ligera Forzada |
|---|---|---|---|---|---|---|---|
| `ultraLowEnd2Gb` (Gama baja extrema) | `lightweight` | 2 GB | 20 imgs / 8 MB | 3 fichas | 6 items | 280 ms | Si |
| `lowEnd3Gb` (Gama baja - Respaldo seguro) | `balanced` | 3 GB | 35 imgs / 14 MB | 5 fichas | 8 items | 220 ms | Si |
| `budgetMid4Gb` (Gama media economica) | `full` | 4 GB | 50 imgs / 24 MB | 8 fichas | 10 items | 160 ms | No |
| `adverseConditions` (Red inestable + BG) | `lightweight` | 2.5 GB | 20 imgs / 8 MB | 3 fichas | 6 items | 300 ms | Si |

## 4. Gestion de Memoria RAM y Liberacion Automatica (`DeviceMemoryGuard`)
- `NexIdApp` implementa `WidgetsBindingObserver` y escucha `didHaveMemoryPressure()` y `didChangeAppLifecycleState(AppLifecycleState.paused / detached)`.
- Al recibir señal de presion de memoria o pasar a segundo plano, `DeviceMemoryGuard.instance.evictTransientMemory()` limpia `PaintingBinding.instance.imageCache`, vacia la cache LRU de expedientes extendidos (`StudentsRepository.clearDetailCache()`) y `SettingsController.onRuntimeMemoryPressure()` degrada automaticamente el perfil si es necesario.
- **Regla critica**: La limpieza de memoria temporal **nunca** elimina ni altera registros pendientes de sincronizacion en SQLite (`outbox` / `RecordsRepository`).

## 5. Priorizacion de Procesos (`lib/core/performance/priority_task_scheduler.dart`)
- **Prioridad Critica (`TaskPriority.critical`)**: Interaccion del usuario, lectura/validacion fisica NFC (`ReadingController.simulateScan`) y creacion de registros (`RecordsController.createRecord`). Se ejecutan de inmediato y detienen el inicio de tareas de baja prioridad.
- **Prioridad Media (`TaskPriority.medium`)**: Carga paginada de alumnos/registros visibles e hidratacion de pestañas academicas al abrir un expediente.
- **Prioridad Baja (`TaskPriority.low`)**: Compilacion de reportes PDF (`ReportsController.requestReport`) delegada a un `Isolate.run` secundario para no bloquear el hilo principal de UI.
