# Estado actual

- Producto confirmado: Android Flutter, lectura NFC y QR, alumnos/lugares/registros/fotos, servidor con BD y reportes.
- Host raíz confirmado: nexlabs.net.pe. Sistema exclusivamente en subdominio por elegir; sitio principal protegido.
- NFC: ficha completa autorizada. QR: proyección parcial según modalidad. Token en tarjeta y resolución server-side son propuesta técnica.
- Hecho: kit modular de Markdown con modelo de datos, API propuesta, archivos, flujo móvil y plan de servidor.
- Pendiente: tipo NFC/formato, significado de registro, campos/roles, subdominio y versiones/capacidades PHP/MariaDB/cron; consultar 04_PRODUCTO.md.
- Marca: azul #1D4ED8, morado #DDD6FE, Roboto, assets en archivos, cero emojis.
- Versión prevista de app: 0.0.0; cambios en Unreleased. No hay app ni servidor ejecutados.
- Autorización: actualización del diseño documental. No se modificaron permisos, infraestructura, BD ni sitio Nexlabs.
- Próxima acción: confirmar los pendientes que bloquean integración; después crear código local por incrementos.
- Historial: CHANGELOG.md; detalles de esta actualización en changes/DOC-NEXLABS-001.md.

Mantener este archivo corto. No copiar toda la conversación ni releer todos los documentos al retomar.

- Confirmado después: PHP para servidor y SQLite local como respaldo/cache/outbox.
- Política de carga: dos pasadas, intervalo de 5 segundos, fallidos al final; segundo fallo solicita revisión manual. Idempotencia/conciliación evitan duplicar efecto tras latencia.
- Pendiente de acordar: alcance/retención caché, operación en background y reglas de eventos capturados offline.

- MariaDB central confirmada. SQLite local tiene subconjunto suficiente para uso y visualización, con precarga selectiva autorizada y miniaturas cuando hagan falta; no toda la base.
- Diseño de uso local/sync en 23_CACHE_USABLE.md; falta acordar campos mínimos, vigencia/retención y ámbito.
