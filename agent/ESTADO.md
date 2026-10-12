# Estado actual

- Producto confirmado: Android Flutter, lectura NFC y QR, alumnos/lugares/registros/fotos, servidor con BD y reportes.
- Host raíz confirmado: nexlabs.net.pe. Sistema exclusivamente en subdominio por elegir; sitio principal protegido.
- NFC: ficha completa autorizada. QR: proyección parcial según modalidad. Token en tarjeta y resolución server-side son propuesta técnica.
- Hecho: kit modular de Markdown con modelo de datos, API propuesta, archivos, flujo móvil y plan de servidor.
- Pendiente: tipo NFC/formato, significado de registro, campos/roles, subdominio y versiones/capacidades PHP/MariaDB/cron; consultar 04_PRODUCTO.md.
- Marca: azul #1D4ED8 y variantes azules/neutras suaves (#EFF6FF / #172554), Roboto, assets en archivos, cero emojis.
- Versión actual de la app: 0.0.9+9 (actualizada según entregas VIS-A [0.0.1+1], VIS-B [0.0.2+2], VIS-C [0.0.3+3], VIS-D [0.0.4+4], FUN-2/VIS-E [0.0.5+5], VIS-F/FUN-3 [0.0.6+6], PERF-0 [0.0.7+7], HW-AUTO-SETTINGS [0.0.8+8] y VIS-SETTINGS-FINAL [0.0.9+9]).
- Estado Rendimiento (Prioridad 0), Hardware Real, Configuración Definitiva y Accesibilidad: Detección nativa de hardware Android en Kotlin (`DeviceCapabilitiesManager.kt` -> `DeviceCapabilitiesSnapshot`) con adaptación inteligente automática por defecto (`isAutoPerformance = true`, verificada mediante `isDetectionCompleted`); diseño visual definitivo del apartado **Configuración** (`SettingsPage`: encabezado compacto con flecha de regreso e icono de ajustes, buscador redondeado «Buscar un ajuste...», tarjeta destacada **Optimización del dispositivo** con `Estado: Automática` y lista vertical de 8 categorías con subpantallas dedicadas); y **Configuración avanzada** oculta de la lista principal y restringida por permisos reales de Administrador (`SessionController.canAccessAdvancedSettings`). 0 warnings en `flutter analyze` y 8 suites/tests aprobados en `flutter test`.
- Regla no-monolitos: 100% cumplida (<250 líneas por archivo, funciones <40 líneas).
- Servidor / backend: sin intervenir aún (modo 100% local según requerimiento del usuario).
- Próxima acción: consultar `docs/PROGRESS.md` y `docs/DECISIONS.md` al iniciar cualquier sesión; acordar integración con servidor PHP/MariaDB cuando el usuario lo autorice.
- Historial: CHANGELOG.md; misiones en `docs/missions/`.

Mantener este archivo corto. No copiar toda la conversación ni releer todos los documentos al retomar.

- Confirmado después: PHP para servidor y SQLite local como respaldo/cache/outbox.
- Política de carga: dos pasadas, intervalo de 5 segundos, fallidos al final; segundo fallo solicita revisión manual. Idempotencia/conciliación evitan duplicar efecto tras latencia.
- MariaDB central confirmada. SQLite local tiene subconjunto suficiente para uso y visualización, con precarga selectiva autorizada y miniaturas cuando hagan falta; no toda la base.
