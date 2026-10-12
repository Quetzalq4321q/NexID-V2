# Modelo de datos propuesto

Motor confirmado: MariaDB central, con base y usuario propios del subdominio. Esquema lógico propuesto, aún no migración ejecutada. Proponer InnoDB para tablas transaccionales con claves foráneas; confirmar versión. Migraciones versionadas y consultas parametrizadas.

## Tablas y relaciones
| Tabla | Campos mínimos propuestos | Restricciones |
|---|---|---|
| users | id, login, password_hash, status, timestamps | login único; contraseña nunca en texto |
| roles / permissions | id, code | códigos únicos, permisos del servidor |
| user_roles / role_permissions | claves de relación | FKs y combinación única |
| students | id, student_code, display_name, status, profile_media_id, timestamps | código único; más campos se acuerdan |
| places | id, code, name, status, timestamps | código único; no implica GPS |
| credentials | id, student_id, kind, token_verifier, status, expires_at, revoked_at, timestamps | kind nfc/qr; verificador único; FK alumno |
| qr_modalities | id, code, field_policy, status | política validada en servidor, no script |
| credential_modalities | credential_id, modality_id | solo credenciales QR; integridad en servicio/BD |
| records | id, student_id, place_id, credential_id, operator_id, event_type, occurred_at, received_at, status, idempotency_key | FKs, idempotencia por operador/ámbito acordado |
| media | id, storage_key, detected_type, byte_size, hash, uploaded_by, status, timestamps | storage_key único; contenido privado |
| student_media | student_id, media_id, purpose | vinculación autorizada y combinación única |
| report_jobs | id, requested_by, report_type, parameters, status, output_media_id, progress, timestamps | scope por usuario/lugares |
| audit_events | id, actor_id, action, resource_type, resource_id, request_id, occurred_at | mínimo dato necesario, sin tokens/datos completos |

profile_media_id -> media.id identifica foto actual. student_media permite historial/documentos si se confirman; no implementarlo sin necesidad. No crear tabla genérica x; preguntar su significado. No guardar cualquier JSON del cliente en students sin esquema.

## Reglas
- Elegir formato de ID coherente; representar IDs como cadenas en API para evitar pérdida de precisión.
- Separar cuentas operadoras de alumnos; no inventar cuentas para cada alumno.
- Un alumno puede tener varias credenciales según política, con revocación independiente. Token del QR no coincide por defecto con NFC.
- records aún no significa asistencia ni ingreso/salida. event_type es un catálogo aprobado, no un valor libre con lógica improvisada.
- occurred_at conserva momento de evento declarado; received_at es hora del servidor. UTC en almacenamiento; visualización/reportes con zona acordada, propuesta America/Lima.
- El lugar debe estar dentro del alcance autorizado del operador. No aceptar student_id o actor_id del cliente sin validación.
- Mantener los registros como historial: una corrección enlaza/anula según regla aprobada, no borra silenciosamente ni altera hechos para arreglar un fallo.
- Transacción para insertar registro y marcar idempotencia. Reintento con misma clave/cuerpo devuelve mismo resultado; misma clave/cuerpo distinto produce conflicto.
- Borrados en cascada de alumnos no deben eliminar registros automáticamente. Definir retención/anónimización antes de cambiar datos reales.
- Fotos/archivos se guardan en almacenamiento privado; BD guarda metadatos y referencias, no URLs públicas con datos sensibles.

## Índices y concurrencia
Proponer índices según consultas: student_code; places.code; credentials.token_verifier; records(student_id, occurred_at, id); records(place_id, occurred_at, id); records(operator_id, idempotency_key); report_jobs(requested_by, created_at). Medir y ajustar, no indexar todo. Paginación estable con id como desempate.

## Migraciones y recuperación
Crear base nueva, datos ficticios y migración inicial en prueba. No ejecutar sobre tablas de Nexlabs. Antes de aplicar cambios reales: aprobación, respaldo consistente de BD más archivos y prueba de restauración en destino aislado. Versionar migración y pasos de rollback/forward fix; no asumir que revertir Git recupera datos borrados.

## Continuidad móvil/servidor
SQLite local se diseña en 20_SQLITE_LOCAL.md y 23_CACHE_USABLE.md; MariaDB es el motor remoto confirmado. Agregar recibos idempotentes y jobs centrales según 22_SERVIDOR_PHP.md. Cada operación mantiene un único ID entre móvil y servidor para resolver timeout tras commit.

## MariaDB
Tablas transaccionales y FKs con InnoDB según versión. Commit de registro y recibo idempotente en una transacción. DDL puede causar commit implícito: revertir transacciones no reemplaza un plan de recuperación de migraciones. Referencias: https://mariadb.com/docs/server/reference/sql-statements/transactions/start-transaction y https://mariadb.com/docs/server/ha-and-performance/optimization-and-tuning/optimization-and-indexes/foreign-keys, revisadas 2026-10-11.
