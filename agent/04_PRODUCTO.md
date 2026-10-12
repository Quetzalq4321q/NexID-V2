# Producto: sistema Android NFC/QR conectado a Nexlabs

## Confirmado por el usuario
- Primera plataforma: Android con Flutter y Android Studio.
- App conectada a servidor y base de datos, con consultas frecuentes.
- Dominio disponible: https://nexlabs.net.pe/. El sistema se instala en UN SUBDOMINIO; no se modifica el index global, rutas ni archivos del sitio principal.
- Lectura de tarjetas NFC y códigos QR. NFC permite ficha completa; QR muestra información parcial o según modalidad.
- Servidor maneja alumnos, lugares, registros, fotos de perfil y datos/archivos que se suban. Incluye consultas y reportes recurrentes.
- Validar y restringir tipos de archivos admitidos.
- PHP queda confirmado como lenguaje del servidor. Node.js/Python ya no son opciones pendientes; MariaDB confirmada como BD central; versiones de PHP/MariaDB y framework por confirmar.
- Posible acceso FTPS/SFTP, según lo indicado por el usuario; no se proporcionaron credenciales. No asumir acceso existente ni pedir contraseñas en Markdown.

## Propuesta técnica inicial, aún no desplegada
Tarjeta/QR identifican una credencial; datos y fotos viven en el servidor. NFC consulta ficha completa AUTORIZADA y QR consulta una proyección parcial según política del servidor. No escribir el expediente completo en la tarjeta por defecto. SQLite local queda confirmado como respaldo ante latencia/saturación: caché permitida y cola persistente. Si se necesitan datos físicamente grabados en tarjeta o autorizaciones sin red, acordar alcance y protección.

Una lectura y un registro son acciones distintas: resolver una tarjeta no crea automáticamente asistencia, entrada, salida ni otro evento. Definir primero qué significa registro.

## Pendientes que afectan implementación
1. Modelo de tarjeta y formato: NDEF, UID existente u otro protocolo; aportar ejemplo anonimizado de contenido NFC/QR.
2. Qué se registra: consulta, asistencia, ingreso/salida u otra actividad; campos y reglas contra duplicados.
3. Campos exactos de ficha completa y campos permitidos en cada modalidad QR.
4. Usuarios/roles y quién administra, lee, registra, sube archivos y genera reportes.
5. Subdominio elegido y hosting: panel, versión/extensiones PHP, versión/extensiones de MariaDB, cron/worker, almacenamiento y TLS.
6. Si lugares son solo ubicaciones operativas o requieren asociación permanente con alumnos. No asumir matrícula ni geolocalización.
7. Qué significa la tabla adicional mencionada como x: no crear una tabla literal x sin requisitos.
8. Frecuencia real de consultas/reportes, tamaños y formato de importaciones; alcance y vigencia de datos offline.

El diseño documental está autorizado. No hay permiso implícito para alterar el sitio principal ni migrar datos de producción.

## Continuidad confirmada por el usuario
SQLite en la app conserva pendientes y datos permitidos ante latencia/fallo; PHP en servidor. Cargas en intervalos de 5 segundos, las no aceptadas pasan al final y se reintentan; segundo fallo requiere revisión manual. Interpretación operativa: dos pasadas, no dos envíos simultáneos; detalle y excepciones en 21_COLA_5_SEGUNDOS.md.

## Precisión de almacenamiento local
SQLite debe guardar suficiente información para uso y visualización conocidos ante fallos, con precarga selectiva, no todos los datos del servidor. Conjunto mínimo propuesto y control de frescura en 23_CACHE_USABLE.md.
