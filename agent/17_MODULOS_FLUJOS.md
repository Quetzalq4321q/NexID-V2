# Módulos y pantallas propuestos

## Monorepo si se inicia desde cero
- AGENTS.md y agent/: contrato común, lectura selectiva.
- mobile/: proyecto Flutter, android/ generado por SDK.
- server/: PHP modular, módulos y migraciones propios.
- contracts/: OpenAPI y esquemas cuando estén definidos.
- Backups FUERA de esta raíz; no carpeta backups dentro del monorepo.

En un proyecto Flutter existente no moverlo a mobile/ sin necesidad. Las rutas lib/ de 02_ARQUITECTURA.md son relativas al proyecto Flutter. Se comparten reglas y contratos, no clases ejecutables entre Dart y el backend.

## Flutter
| Módulo | Responsabilidad |
|---|---|
| session | Login/sesión, permisos de uso de la app |
| reading | Coordinador de captura y resolución NFC/QR |
| students | Ficha y edición autorizada, foto |
| places | Selección/consulta de lugares autorizados |
| records | Creación/consulta de eventos definidos |
| uploads | Validación UX, progreso y subida permitida |
| reports | Solicitar job, estado y descarga |
| core/network | Cliente HTTP, timeouts, request_id y sesión |

Adaptadores NFC/cámara en archivos distintos; controlador de lectura los coordina. Una sola ficha de alumno con componentes compartidos; renderiza proyección del servidor. Una foto visible en lectura no activa acceso a toda galería.

## Servidor
Módulos session, students, places, credentials, records, uploads, imports, reports y audit. Cada módulo: rutas/controlador, validación, servicio y repositorio necesarios. app compone rutas; shared aporta auth, DB, storage, logging y jobs. Report worker PHP CLI/cron separado del handler HTTP, según hosting.

Un front controller index.php propio del subdominio puede componer rutas si se elige PHP. Está prohibido modificar el index global de Nexlabs; index.php exclusivo del subdominio no contiene toda la lógica del sistema.

## Pantallas mínimas propuestas
1. Acceso cuando no hay sesión.
2. Leer: lugar cuando el flujo lo requiere, elegir NFC/QR, resultado de captura.
3. Ficha: información completa/parcial permitida y acción concreta de registro solo si se aprobó el evento.
4. Registros: lista filtrada, paginada y sin detalles de relleno.
5. Alumnos/edición/foto: solo para quienes administran, si el alcance final lo incluye en móvil.
6. Reportes: filtros necesarios, estado y descarga; jobs sin bloqueo de pantalla.

No agregar panel web ni consola de administración por defecto: confirmar dónde se administrarán datos. No mostrar todas las secciones a todos los roles. Cada acción mantiene validación del servidor.

Visual: azul/morado sólidos, Roboto, assets en archivos, controles claros. En ancho amplio se puede dividir lista/ficha compartiendo estado; en compacto mostrar una tarea por vista. Lectura no agrega pantalla introductoria ni información innecesaria.

## Respaldo confirmado
Añadir core/local_database para adaptador SQLite y módulo sync con outbox_repository, sync_coordinator, operation_status y manual_review separados. No meter cola/reintentos dentro de páginas ni main.dart. Mostrar pendiente/confirmado/revisión como estados concretos; detalle de revisión solo ante caso real, no pantalla de relleno.
