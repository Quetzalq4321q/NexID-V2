# Contrato API inicial propuesto

Base configurable: https://<subdominio-elegido>.nexlabs.net.pe/api/v1. No usar ese placeholder en una compilación distribuida. No llamar rutas del index global. Contrato definitivo depende de roles, campos y eventos aprobados.

| Método y ruta relativa | Responsabilidad | Protección |
|---|---|---|
| GET /health | Estado mínimo del servicio | Sin datos, versiones privadas ni secretos |
| POST /auth/login | Crear sesión operadora | Rate limit y errores sin enumeración |
| POST /auth/refresh | Renovar sesión según mecanismo elegido | Rotación/revocación coherentes |
| POST /auth/logout | Revocar sesión | Sesión actual |
| POST /credentials/resolve | Resolver token NFC/QR | Scope lectura + proyección del servidor |
| GET /students | Consulta paginada mínima | Scope alumnos y campos autorizados |
| POST /students | Crear alumno | Scope administración |
| PATCH /students/{id} | Editar campos permitidos | Scope y control de concurrencia |
| GET /places | Lugares autorizados | Sesión/alcance |
| POST /records | Crear evento aprobado | Scope registro, idempotencia, validación |
| GET /records | Consulta filtrada paginada | Alcance por usuario/lugar |
| POST /students/{id}/photo | Subir foto y actualizar referencia | Upload de propósito foto |
| POST /imports | Importar TXT del esquema acordado | Scope importación; job si es pesado |
| GET /imports/{id} | Estado y errores de importación | Dueño/scope; sin contenido privado extra |
| GET /media/{id}/content | Entrega privada de archivo | Permiso real sobre recurso vinculado |
| POST /reports | Solicitar job de reporte | Scope y cuota de reportes |
| GET /reports/{id} | Estado del job | Dueño/alcance autorizado |
| GET /reports/{id}/download | Descargar reporte terminado | Scope verificado otra vez |

No se implementan todos los endpoints solo por estar listados; elegir incremento y contrato real. Una ruta genérica de archivos requiere propósito explícito y política distinta por propósito; no abrir uploads arbitrarios.

## Resolución
Entrada: token, observed_source (nfc/qr), place_id cuando aplica y formato_version. observed_source es telemetría declarada, NO prueba del medio. El servidor obtiene tipo y modalidad de la credencial y combina sus permisos con la sesión. Respuesta: read_id, credential_kind, visibility (full/partial), modality, student_projection y allowed_actions. Solo contiene campos permitidos; allowed_actions es guía de UI y el servidor vuelve a validar cada acción.

No enviar expediente, documento de identidad, foto o campos adicionales si QR no los permite. No aceptar un parámetro fields=all/full=true para eludir la política. Datos completos nunca se consideran públicos por conocer un token.

## Consistencia
- POST /records: cabecera Idempotency-Key, validación server-side y operación atómica. Timeout tras commit: reintento seguro con misma clave; no generar otra clave hasta resolver resultado.
- GET de listados: límite máximo, cursor opaco estable, filtros allowlist y orden definido; no consultas ilimitadas.
- PATCH: versión/ETag o mecanismo equivalente para evitar que dos operadores se sobrescriban.
- Todas las fechas ISO-8601 con zona. Validar tamaño/forma de JSON y campos desconocidos.
- Errores breves: code, message, request_id; sin stack, SQL o payload de credencial. 401 sesión; 403 alcance; 404 recurso; 409 conflicto; 413 tamaño; 415 tipo; 422 datos; 429 rate limit; 5xx fallo interno.
- Política de no enumeración para credenciales desconocidas/inaccesibles; evitar respuestas que permitan deducir alumnos.
- Cache y fotos respetan política del recurso: no cache compartida de expediente. Un refresh en vuelo y reintento limitado; evitar bucle infinito de login.
- El servidor NO debe visitar URLs arbitrarias suministradas por cliente/QR para descargar fotos; las fotos se suben por flujo validado.

Contrato final se expresa en OpenAPI para el backend PHP. Este Markdown es una propuesta para implementarlo, no evidencia de endpoints existentes.

## Sincronización PHP/SQLite
GET /operations/{operation_id}: estado/result/job_id de la operación dentro del ámbito autorizado. POST de cargas: clave estable y respuesta durable 200/201 o 202 según 21_COLA_5_SEGUNDOS.md. Dos pasadas móviles, sin multiplicar reintentos en cliente HTTP. Límites/errores no son confirmaciones; Retry-After acompaña rechazo recuperable cuando corresponda.

## Datos locales utilizables
Propuestas GET /sync/bootstrap y GET /sync/changes con paginación/cursor por scope, proyección autorizada, fecha/version y revocaciones. Implementar según 23_CACHE_USABLE.md; ninguna ruta puede exportar expediente global para llenar SQLite.
