# SQLite local como respaldo operativo

## Confirmado
App Android con pequeña SQLite para mantener estado/cargas cuando el servidor tenga latencia, esté caído o saturado. Es caché y outbox persistente, no reemplazo de BD central ni garantía de validar credenciales sin conexión.

## Límites
- Servidor es autoridad de identidad, permisos, revocación y registros confirmados.
- UI nunca espera indefinidamente: estado local y carga pendiente; operaciones de red asíncronas con timeout.
- GET usa caché autorizada por recurso/usuario/modalidad cuando exista; si no existe, mostrar falta de datos. No encolar cada consulta de lectura como escritura.
- Registrar local y encolar la operación en UNA transacción. La UI confirma “guardado en este dispositivo”, no “registrado en servidor”. Al recibir confirmación válida, actualizar estado con ID remoto.
- Una captura sin red puede conservarse como pendiente de validación si el flujo aprobado lo permite. No conceder acceso físico ni mostrar información completa nueva por reconocer un token local.

## Tablas locales mínimas propuestas
| Tabla | Responsabilidad / campos |
|---|---|
| cached_students | proyección permitida, user_scope, credential_scope, modality, updated_at, expires_at |
| cached_places | catálogo autorizado y versión/expiración |
| local_records | local_id, campos del evento aprobado, remote_id, sync_status, timestamps |
| outbox | operation_id, kind, payload_schema_version, payload, payload_hash, actor_scope, state, pass, attempt_count, batch_id, next_attempt_at, lease, last_error_code, remote_id |
| upload_files | operation_id, ruta privada, tamaño, checksum, propósito, estado; bytes fuera de SQLite |
| sync_metadata | versión esquema, checkpoints/cursor y configuración de sincronización |

Crear solo tablas realmente usadas; imágenes grandes no van como BLOB por defecto. Payload de outbox es datos validados de un tipo conocido, no código ejecutable ni HTTP arbitrario. Dependencias (alumno/foto/registro) tienen orden explícito; no enviar registro antes de que exista su dependencia.

## Persistencia y seguridad
- Adaptador SQLite separado de repositorio, caché y coordinador de sync. Elegir sqflite u otra solución mantenida; no mezclar dos engines sin motivo. Consultas parametrizadas y transacciones breves; no HTTP dentro de transacción.
- SQLite normal no cifra automáticamente. Datos mínimos; protección en almacenamiento privado y cifrado adecuado si la sensibilidad lo exige. Claves/tokens de sesión en mecanismo seguro respaldado por Android Keystore, no en texto dentro de la BD.
- Aislar caché por usuario, alcance y modalidad. QR nunca usa caché de ficha completa NFC. Expiración visible; no confundir datos vencidos con actuales.
- Cierre de sesión: invalidar caché/sesión según política; NO enviar pendientes del usuario anterior con credenciales del siguiente. Conservar pendientes aislados para recuperación/revisión sin exponerlos ni borrarlos automáticamente.
- Excluir secretos/caché sensible de copias automáticas no autorizadas y definir recuperación. No borrar DB, resetear app ni migrar destructivamente para resolver SQLITE_BUSY/corrupción.
- Reiniciar app conserva cola; lease vencido de operación “enviando” lleva a conciliación con servidor antes de repetir. Reconstruir estado con operation_id.
- Límites de filas/bytes y limpieza solo de caché expirada o operaciones confirmadas según retención. Una cola llena avisa y preserva pendientes; no descarta cargas en silencio.
- Backups consistentes: API de backup o mecanismo que considere WAL; no copiar solo .db abierto ignorando archivos auxiliares. Verificar restauración fuera del proyecto.

## Migraciones
Versionar esquema local independientemente de la versión de app. Probar actualización con pendientes de la versión anterior; migrar payloads compatiblemente. No usar borrado/recreación como migración. Cambios reales del núcleo/BD siguen 05_CAMBIOS.md; el diseño SQLite fue solicitado explícitamente por el usuario.

Referencias: https://docs.flutter.dev/cookbook/persistence/sqlite y https://www.sqlite.org/atomiccommit.html; consultadas 2026-10-11.

## Conjunto útil confirmado
No es solo cola: precargar selectivamente datos mínimos de alumnos, lugares, modalidades y miniaturas autorizadas para visualización usable. Política/flujo en 23_CACHE_USABLE.md. MariaDB central confirmada; SQLite no contiene todo.
