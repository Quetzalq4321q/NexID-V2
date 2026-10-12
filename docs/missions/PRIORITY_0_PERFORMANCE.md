# Mision: PRIORIDAD 0 — Optimizacion para Dispositivos de 2 a 4 GB de RAM

## 1. Objetivo Innegociable
Garantizar fluidez, estabilidad y respuesta tactil inmediata en celulares Android economicos (Samsung Galaxy A13, Samsung Galaxy A14, Xiaomi Redmi 15C y equivalentes con 2 GB, 3 GB o 4 GB de RAM, CPU lenta, almacenamiento eMMC lento y red movil intermitente).

## 2. Perfiles de Hardware Simulados (`lib/core/performance/device_performance_tier.dart`)
| Perfil (`DevicePerformanceProfile`) | RAM Total | Cache Imagenes (`maxImageCacheCount` / `Bytes`) | Fichas Extendidas en RAM (`BoundedLruCache`) | Lote Paginacion (`listPageSize`) | Debounce Busqueda | UI Ligera Forzada |
|---|---|---|---|---|---|---|
| `ultraLowEnd2Gb` (Gama baja extrema) | 2 GB | 20 imgs / 8 MB | 3 fichas | 6 items | 280 ms | Si |
| `lowEnd3Gb` (Gama baja - Por defecto) | 3 GB | 35 imgs / 14 MB | 5 fichas | 8 items | 220 ms | Si |
| `budgetMid4Gb` (Gama media economica) | 4 GB | 50 imgs / 24 MB | 8 fichas | 10 items | 160 ms | No |
| `adverseConditions` (Red inestable + BG) | 2.5 GB | 20 imgs / 8 MB | 3 fichas | 6 items | 300 ms | Si |

## 3. Gestion de Memoria RAM y Liberacion Automatica (`DeviceMemoryGuard`)
- `NexIdApp` implementa `WidgetsBindingObserver` y escucha `didHaveMemoryPressure()` y `didChangeAppLifecycleState(AppLifecycleState.paused / detached)`.
- Al recibir señal de presion de memoria o pasar a segundo plano, `DeviceMemoryGuard.instance.evictTransientMemory()` limpia `PaintingBinding.instance.imageCache` y vacia la cache LRU de expedientes extendidos de alumnos (`StudentsRepository.clearDetailCache()`).
- **Regla critica**: La limpieza de memoria temporal **nunca** elimina ni altera registros pendientes de sincronizacion en SQLite (`outbox` / `RecordsRepository`).

## 4. Priorizacion de Procesos (`lib/core/performance/priority_task_scheduler.dart`)
- **Prioridad Critica (`TaskPriority.critical`)**: Interaccion del usuario, lectura/validacion fisica NFC (`ReadingController.simulateScan`) y creacion de registros (`RecordsController.createRecord`). Se ejecutan de inmediato y detienen el inicio de tareas de baja prioridad.
- **Prioridad Media (`TaskPriority.medium`)**: Carga paginada de alumnos/registros visibles e hidratacion de pestañas academicas al abrir un expediente.
- **Prioridad Baja (`TaskPriority.low`)**: Compilacion de reportes PDF (`ReportsController.requestReport`) delegada a un `Isolate.run` secundario para no bloquear el hilo principal de UI.
