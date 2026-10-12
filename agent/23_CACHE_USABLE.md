# Conjunto local suficiente para uso y visualización

## Confirmado por el usuario
MariaDB guarda datos centrales. SQLite de la app NO contiene todo: mantiene lo suficiente para seguir siendo usable y mostrar correctamente información conocida cuando falle o tarde la conexión.

## Conjunto local propuesto, sujeto a campos/roles acordados
| Datos | Qué conservar | Qué evitar |
|---|---|---|
| Alumno | ID/código, nombre visible, estado conocido y campos mínimos autorizados para tarea | Expediente completo, campos sensibles sin necesidad |
| Foto | Miniatura privada de perfiles dentro del ámbito autorizado, si se necesita identificación visual | Galería completa o fotos originales de todos |
| Lugar | ID/código/nombre de lugares permitidos | Catálogo global ajeno al operador |
| Modalidad QR | Política/version y proyección parcial autorizada | Usar ficha full NFC como fallback de QR |
| Actividad | Pendientes propios y resumen reciente relevante | Historial completo del servidor |
| Sync | Versiones/cursor, fecha/expiración, cola, claves idempotentes y conflictos | Secretos de sesión en texto |

Es una propuesta de mínimo útil; acordar los campos que constituyen una ficha usable. No descargar todos los alumnos/archivos por defecto. Aplicar ámbito por usuario/lugar, límites locales y precarga de los datos necesarios; simple caché oportunista de pantallas ya abiertas no garantiza uso offline inicial.

## Consulta durante latencia
1. Si hay datos locales autorizados, presentar ficha disponible inmediatamente con fecha y estado local.
2. Refrescar asíncronamente si hay red; al responder, actualizar SQLite/proyección y UI de forma consistente.
3. Timeout o error mantiene datos anteriores identificados como locales; no congelar pantalla ni borrar la ficha.
4. Sin datos locales mostrar no disponible y acción de reintentar; no inventar nombre/foto ni confundir alumno con el anterior.
5. Ficha de NFC que llega del servidor puede ser completa; en fallback local mostrar únicamente el subconjunto disponible y no llamarlo “ficha completa actualizada”.

## Sincronización selectiva
- Propuesta GET /sync/bootstrap con conjunto autorizado y versión/cursor, paginado y limitado; no exportación global de BD.
- Propuesta GET /sync/changes?cursor=... devuelve cambios y tombstones/revocaciones autorizadas. Cursor pertenece a usuario/scope y avanza solo al persistir la página correctamente.
- Snapshot inicial consistente y cursor de corte; deltas posteriores cubren cambios durante descarga. No copiar ficheros SQL desde MariaDB a SQLite.
- Aplicar datos/version y checkpoint en transacción local; actualizar miniaturas con checksum y referencias. No sobrescribir acciones locales pendientes con respuestas de caché.
- Si permisos/scope cambian, reconciliar o invalidar el subconjunto. Revocaciones conocidas se aplican; las desconocidas sin red no pueden garantizarse.
- Definir vigencia/retención y condiciones de uso offline antes de activar. La fecha visible es obligatoria. Consulta local no autentica de nuevo una tarjeta ni concede autorización crítica offline.
- Fotos y filas cacheadas: cuota/LRU para datos prescindibles; nunca limpiar outbox o ficheros de carga pendientes por falta de espacio.

## Mensajes cortos sugeridos
“Datos locales · actualizado <fecha>”, “Actualizando”, “Pendiente de enviar”, “Confirmado por servidor”, “Requiere revisión”. No agregar páginas de información extra; usar estado junto a la tarea. No mostrar una fecha ficticia.

## Pruebas de uso
Precarga con ámbito, primera apertura sin red, foto conocida/no cacheada, ficha QR parcial, latencia sin bloqueo, dato cambiado/revocado, usuario diferente, cursor repetido, página cortada, caché expirada, cuota local y actualización del esquema con pendientes.
