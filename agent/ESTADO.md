# Estado actual

- Producto confirmado: Android Flutter, lectura NFC y QR, alumnos/lugares/registros/fotos, servidor con BD y reportes.
- Host raíz confirmado: nexlabs.net.pe. Sistema exclusivamente en subdominio por elegir; sitio principal protegido.
- NFC: ficha completa autorizada. QR: proyección parcial según modalidad. Token en tarjeta y resolución server-side son propuesta técnica.
- Hecho: kit modular de Markdown con modelo de datos, API propuesta, archivos, flujo móvil y plan de servidor.
- Pendiente: tipo NFC/formato, significado de registro, campos/roles, subdominio y versiones/capacidades PHP/MariaDB/cron; consultar 04_PRODUCTO.md.
- Marca: azul #1D4ED8, morado #DDD6FE, Roboto, assets en archivos, cero emojis.
- Versión actual de la app: 0.0.6+6 (actualizada según entregas VIS-A [0.0.1+1], VIS-B [0.0.2+2], VIS-C [0.0.3+3], VIS-D [0.0.4+4], FUN-2/VIS-E [0.0.5+5] y VIS-F/FUN-3 [0.0.6+6]).
- Estado UI, Accesibilidad y Hardware: Sistema de accesibilidad WCAG 2.2 con detección automática del tema del SO (Claro, Oscuro y Automático independientes mediante `NexIdPalette`), escala de fuente (90%-130%), alto contraste, reducción de movimiento, Skeleton Loading modular (`DataStateBoundary`, `StudentListSkeleton`, `RecordListSkeleton`), expediente integral de alumnos por pestañas, módulo de registros auditable con paginación y vista previa interactiva de documentos PDF en formato A4 (`PdfPreviewPage`), junto con lectura física NFC y escaneo QR en Kotlin. 0 warnings en `flutter analyze`.
- Regla no-monolitos: 100% cumplida (<250 líneas por archivo, funciones <40 líneas).
- Servidor / backend: sin intervenir aún (modo 100% local según requerimiento del usuario).
- Próxima acción: revisar la vista previa del PDF A4 con el usuario para generar la documentación Markdown específica del PDF cuando lo solicite, y acordar integración con servidor PHP/MariaDB.
- Historial: CHANGELOG.md; detalles en agent/24_ACCESIBILIDAD_Y_TEMAS.md.

Mantener este archivo corto. No copiar toda la conversación ni releer todos los documentos al retomar.

- Confirmado después: PHP para servidor y SQLite local como respaldo/cache/outbox.
- Política de carga: dos pasadas, intervalo de 5 segundos, fallidos al final; segundo fallo solicita revisión manual. Idempotencia/conciliación evitan duplicar efecto tras latencia.
- MariaDB central confirmada. SQLite local tiene subconjunto suficiente para uso y visualización, con precarga selectiva autorizada y miniaturas cuando hagan falta; no toda la base.
