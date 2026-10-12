# Implementación del servidor PHP

## Stack confirmado
PHP en subdominio aislado. No cambiar a Node/Python. Confirmar versión soportada, Composer, PDO con driver compatible MariaDB, imágenes, cron/CLI y límites del hosting. Framework ligero o arquitectura propia según mantenimiento; no inventar versión ni dependencias instaladas.

## Esqueleto propuesto
- server/public/index.php: bootstrap/rutas del SUBDOMINIO exclusivamente.
- server/src/App/: composición e inyección/configuración validada.
- server/src/Modules/<Modulo>/: Controllers, Services, Repositories, Validators y DTOs necesarios.
- server/src/Shared/Database/: PDO y transacciones.
- server/src/Shared/Auth/: sesión, scopes y políticas por recurso.
- server/src/Shared/Storage/: rutas privadas y archivos validados.
- server/src/Shared/Queue/: jobs, reserva/lease, estado y límites.
- server/src/Shared/Logging/: eventos estructurados/request_id sin secretos.
- server/database/migrations/: esquema remoto versionado.
- server/bin/: worker PHP CLI/cron con tiempo y lote delimitados.
- server/tests/: contratos, permisos, transacciones y recuperación.
- Variables reales y storage/uploads/logs: ubicación privada configurada fuera de public y Git. Backups fuera del proyecto.

Una función desde su cuarta reutilización tiene archivo utils específico; servicios y políticas con estado no se degradan a utilidades globales. PSR-4/Composer es propuesta para carga de clases cuando el hosting lo permita.

## Peticiones
Controlador valida tamaño/forma, autentica y delega; servicio aplica política/transacción; repositorio usa PDO con parámetros. Nombres de tablas/columnas/orden provienen de allowlist, no parámetros libres. Manejar excepciones en frontera HTTP con rollback pertinente y error estructurado; no mostrar stack/SQL.

## Cola remota y límites
- Escritura pequeña válida: transacción y 200/201 tras commit. Si se necesita trabajo asíncrono: insertar operación/job durable y responder 202 + ID solo después de commit.
- reports/imports/uploads pesados: worker PHP, no espera larga ni sleep(5) dentro de HTTP para espaciar clientes.
- Tabla operation_receipts: actor_scope, operation_id, payload_hash, status, result/resource/job_id, timestamps; índice único por ámbito+ID y recuperación atómica.
- Tabla server_jobs si se usa: kind, schema/payload validado, status, next_available_at, attempts, lease_owner/expires_at, output/error; claims atómicos y exclusión de ejecución simultánea.
- Saturación: 429/503 con Retry-After y mensaje breve, sin aceptar silenciosamente lo que no se persistió. Límite global complementa el intervalo de cada app.
- Cron ordinario puede ejecutar por minuto y no garantiza intervalos de 5 segundos; los 5 segundos corresponden al despachador móvil. Si se requiere worker continuo, confirmar capacidad PHP CLI/supervisión, no mantener un request abierto simulando un daemon.
- No compartir claves, BD, sesiones ni rutas del sitio raíz. SQLite es local en Android; MariaDB central confirmada; verificar versión, InnoDB y capacidad de conexiones.

## Contrato de sincronización
POST de operaciones con Idempotency-Key; GET /operations/{operation_id} con scope y estado pending/accepted/completed/failed/unknown según estado real. No revelar operaciones ajenas. El servidor vuelve a comprobar credencial/permisos vigentes antes del efecto; que la app haya capturado un evento offline no prueba que deba aceptarse.

Documentar reglas de fecha de captura, revocación durante espera y conflictos; no elegirlas a escondidas. Preparar cambio y migración reversibles, pruebas de commit con respuesta perdida y revisión manual.

Referencias: https://www.php.net/manual/en/pdo.prepared-statements.php y https://www.php.net/manual/en/pdo.transactions.php, revisadas 2026-10-11.
