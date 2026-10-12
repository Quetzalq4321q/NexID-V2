# Mision: Optimizacion de Alumnos, Matricula, Fotografias y Registros (`PRIORIDAD 4`)

## 1. Modulo de Alumnos (`lib/features/students/`)
- **Proyeccion Ligera para Listas**: `StudentsRepository.getStudents()` entrega unicamente los campos minimos de resumen (`id`, `code`, `fullName`, `career`, `status`, `academicPeriod`, `academicCycle`, `attendanceRate`) sin instanciar listas anidadas de cursos o documentos para todo el padron.
- **Hidratacion Bajo Demanda (`BoundedLruCache`)**: Al abrir `StudentFullProfilePage`, `StudentsController.hydrateStudentForProfile` carga los cursos, documentos, observaciones e historial en una cache LRU acotada (`3` fichas en dispositivos de 2 GB RAM, `5` en 3 GB RAM, `8` en 4 GB RAM).
- **Paginacion Progresiva y Debounce**: `StudentsController.paginatedStudents` pagina en bloques de `6` a `10` elementos segun el perfil de RAM y aplica debounce (`160 ms` - `300 ms`) en el buscador para evitar reconstrucciones por tecla pulsada.
- **Miniaturas y Avatares**: `AvatarPlaceholder` mantiene proporciones circulares fijas y `DeviceMemoryGuard` restringe `PaintingBinding.instance.imageCache` a `8 MB` - `24 MB`.

## 2. Modulo de Registros (`lib/features/records/`)
- **Paginacion Progresiva (`pageSize = 6`)**: `RecordsPage` renderiza bloques de 6 registros mediante `ListView.separated` (`addAutomaticKeepAlives: false`, `addRepaintBoundaries: true`).
- **Auditoria Completa (`RecordDetailSheet`)**: Muestra ID de registro, clave de idempotencia, operador responsable, medio (`NFC`/`QR`), estado de sincronizacion e historial cronologico de cambios.
- **Integridad de Outbox**: Los registros pendientes en cola local nunca son purgados por la limpieza de memoria temporal (`DeviceMemoryGuard.evictTransientMemory()`).
