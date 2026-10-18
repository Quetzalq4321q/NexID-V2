# Estado actual

- Producto confirmado: Android Flutter, lectura NFC y QR, alumnos/lugares/registros/fotos, servidor con BD y reportes.
- Host raíz confirmado: nexlabs.net.pe. Sistema exclusivamente en subdominio por elegir; sitio principal protegido.
- NFC: ficha completa autorizada. QR: proyección parcial según modalidad. Token en tarjeta y resolución server-side son propuesta técnica.
- Hecho: kit modular de Markdown con modelo de datos, API propuesta, archivos, flujo móvil y plan de servidor.
- Pendiente: tipo NFC/formato, significado de registro, campos/roles, subdominio y versiones/capacidades PHP/MariaDB/cron; consultar 04_PRODUCTO.md.
- Marca: azul #1D4ED8 y variantes azules/neutras suaves (#EFF6FF / #172554), Roboto, assets en archivos, cero emojis.
- Versión actual de la app: 0.0.10+10 (actualizada según entregas VIS-A [0.0.1+1] a VIS-SETTINGS-FINAL [0.0.9+9] y VIS-ICON-PERSIST-VITALITY [0.0.10+10]).
- Estado Rendimiento, Iconografía, Cargas Vivas y Persistencia: Catálogo centralizado `AppIcons`, logotipo oficial vivo `NexIdAppLogo`, pantalla de bienvenida `StartupSplashScreen` con fondos nativos de cold-boot claro/oscuro, pantallas de carga y estados vacíos no inertes (`LivelyLoadingView` y `EmptyState` con animación suave de entrada optimizada para gama baja), persistencia real en disco mediante `SharedPreferences` de Android vía canal nativo `HardwareBridge` (`savePreferences`/`loadPreferences`), tipografía adaptativa dinámica en modo Claro y Oscuro sin colores fijos, y unificación en el azul institucional `#1D4ED8`. 0 warnings en `flutter analyze` y 15/15 pruebas aprobadas en `flutter test`.
- Regla no-monolitos: 100% cumplida (<250 líneas por archivo, funciones <40 líneas).
- Servidor / backend: sin intervenir aún (modo 100% local según requerimiento del usuario).
- Próxima acción: consultar `docs/PROGRESS.md` y `docs/DECISIONS.md` al iniciar cualquier sesión; acordar integración con servidor PHP/MariaDB cuando el usuario lo autorice.
- Historial: CHANGELOG.md; misiones en `docs/missions/`.

Mantener este archivo corto. No copiar toda la conversación ni releer todos los documentos al retomar.

- Confirmado después: PHP para servidor y SQLite local como respaldo/cache/outbox.
- Política de carga: dos pasadas, intervalo de 5 segundos, fallidos al final; segundo fallo solicita revisión manual. Idempotencia/conciliación evitan duplicar efecto tras latencia.
- MariaDB central confirmada. SQLite local tiene subconjunto suficiente para uso y visualización, con precarga selectiva autorizada y miniaturas cuando hagan falta; no toda la base.
