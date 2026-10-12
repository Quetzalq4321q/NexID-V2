# Inicio para el agente Flutter y servidor

Lee AGENTS.md, agent/00_INDEX.md y agent/01_REGLAS.md. Antes de mutar lee agent/05_CAMBIOS.md. Producto confirmado en agent/04_PRODUCTO.md; no volver a pedir el objetivo general ya explicado. Recupera continuidad en agent/ESTADO.md y carga solo el contexto indicado para tu tarea.

Construye un sistema Android Flutter para leer NFC y QR con servidor PHP, base central MariaDB, alumnos, lugares, registros, fotos y reportes. Implementa servidor en PHP, modular y aislado en un subdominio de nexlabs.net.pe. NO modifiques el index, rutas, base ni archivos globales del sitio principal.

NFC resuelve ficha completa autorizada; QR devuelve solo campos permitidos por modalidad. El servidor aplica permisos y proyección. Antes de implementar confirma modelo/formato de tarjetas, significado de registro, campos, roles, hosting y subdominio. SQLite como caché/cola local ya está confirmado; no inventes asistencia, ingreso/salida, autorización offline, escritura de tarjetas o panel web.

Mantén diseño sólido azul/morado, Roboto, assets en archivos y adaptación de pantallas. Aplica validación restrictiva a fotos/TXT, consultas paginadas, idempotencia de registros y jobs para reportes pesados.

Versiona desde 0.0.0. Cada cambio documenta problema, razonamiento, lógica antes/después, referencias exactas de código, pruebas y reversión. Solicita aprobación previa para núcleo/permisos/datos según alcance, respalda externamente modificaciones inciertas y verifica recuperación. No declarar pruebas, endpoints ni despliegues activos sin evidencia.

Implementa SQLite pequeña con caché permitida y outbox persistente. Cargas espaciadas 5 segundos, no aceptadas al final de la ronda y un reintento final; segundo fallo queda para revisión manual. Idempotencia durable en PHP y conciliación de timeout. Sigue 20_SQLITE_LOCAL.md, 21_COLA_5_SEGUNDOS.md y 22_SERVIDOR_PHP.md; no reenvíes cargas ya aceptadas ni prometas timers exactos en background.

MariaDB es la base central. SQLite no contiene todo: prepara precarga selectiva de información mínima útil para mostrar fichas conocidas y fotos necesarias con estado/fecha visibles, separada de pendientes. Aplica 23_CACHE_USABLE.md y respeta proyecciones QR y scopes, incluso sin red.
