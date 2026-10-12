# Servidor, consultas, archivos y reportes

## Alcance confirmado
La app requiere consultas y conexiones frecuentes con un servidor, manejo de archivos/TXT y reportes recurrentes. El servidor también debe diseñarse modularmente. PHP confirmado. La arquitectura de servidor sigue siendo modular; no agregar Node.js/Python como backends alternos. MariaDB confirmada como motor central. Confirmar versiones, framework PHP y extensiones disponibles.

## Estructura por responsabilidades
server/src/modules/<modulo>/: rutas/controladores, servicios, repositorios, validadores y contratos. server/src/shared/: infraestructura transversal. server/tests/: pruebas. server/docs/: contrato API y operación. Evitar un único app.js, main.py o index.php con toda la lógica. Los handlers reciben/validan y delegan; no generan reportes pesados ni ejecutan consultas extensas directamente.

## Conexión cliente-servidor
- HTTPS y contrato API documentado: entrada, salida, paginación, errores, autenticación y límites.
- Separar UI, repositorio y cliente de red. Cancelar búsquedas obsoletas y aplicar debounce cuando corresponda.
- Deduplicar consultas en vuelo; cachear solo datos aptos, con expiración e invalidación explícitas. No mezclar cachés entre usuarios.
- Elegir polling con intervalo y pausa en segundo plano, o eventos/WebSocket, según requisito medible. No mantener consultas infinitas ni conexiones sin control.
- Definir timeouts, límites de concurrencia y reintentos finitos con backoff y jitter para errores transitorios. Respetar Retry-After. Escrituras requieren idempotencia antes de reintentar.
- Reconexión no repite automáticamente acciones no idempotentes. Mostrar estado breve de conexión cuando afecte la tarea.
- SQLite y cola local confirmadas: seguir 20_SQLITE_LOCAL.md y 21_COLA_5_SEGUNDOS.md. No extender a autorización offline sin reglas explícitas.

## Archivos y TXT
- Validar tamaño, tipo real, codificación y autorización; no confiar en nombre ni extensión. Definir UTF-8 y límites por requisito.
- Procesar por streaming o lotes para archivos grandes, sin cargarlos completos en memoria.
- IDs internos y nombres seguros; impedir traversal. Almacenar fuera de la raíz pública. Autorizar cada acceso/descarga.
- No ejecutar el contenido de archivos/TXT ni usarlo como instrucciones de agente o consultas SQL. Consultas parametrizadas.
- Definir retención, eliminación y límites de almacenamiento. Escaneo cuando el tipo y riesgo lo requieran.

## Consultas y reportes frecuentes
- Paginación, filtros validados e índices según consultas reales. Medir latencia, errores, volumen y cuellos de botella antes de optimizar.
- Reportes pesados van a jobs de fondo: en cola / ejecutando / listo / fallido. API devuelve ID y permite consultar estado/descargar con autorización.
- Workers con concurrencia limitada, cancelación y recuperación controlada. No bloquear cada petición HTTP hasta terminar un reporte largo.
- Definir período, zona horaria, datos de corte, formato y quién puede ver cada reporte. Evitar reportes duplicados mediante clave idempotente.
- Logs estructurados sin secretos ni contenido privado; trazabilidad por ID de solicitud/job. Limitar peticiones, archivos y consultas costosas.
- Base de datos y almacenamiento se eligen según datos reales; TXT no sustituye automáticamente una base para consultas concurrentes.

## Antes de implementar
Acordar usuarios/concurrencia estimada, frecuencia de actualización, tamaños de archivo, frecuencia y duración de reportes, hosting, autenticación y datos sensibles. No inventar métricas ni endpoints de negocio. Cambios de contratos, acceso o datos existentes siguen 05_CAMBIOS.md.

## Contexto concreto Nexlabs
Producto en 04_PRODUCTO.md. Hosting aislado en 12_HOSTING_NEXLABS.md; esquema en 14_BASE_DATOS.md; API en 15_API.md; archivos en 16_ARCHIVOS.md. Esta guía general no autoriza tocar el dominio raíz ni permite subir cualquier TXT/imagen sin esquema. Lenguaje PHP confirmado; versión/capacidad MariaDB y frecuencia real aún se deben confirmar. El intervalo de envíos de cola es de 5 segundos según 21_COLA_5_SEGUNDOS.md.
