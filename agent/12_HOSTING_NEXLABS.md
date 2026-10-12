# Hosting y aislamiento de Nexlabs

## Límite obligatorio
Dominio raíz: https://nexlabs.net.pe/. El sistema vive en un subdominio independiente. Ejemplo propuesto: control.nexlabs.net.pe, pendiente de elección y creación. Este ejemplo NO prueba que el subdominio exista.

No editar index.php/index.html global, .htaccess global, configuración global de rutas, base existente ni archivos públicos del dominio raíz. Si el hosting obliga a cambiar algo compartido, presentar alcance y obtener autorización antes; no hacerlo silenciosamente.

## Aislamiento necesario
- Document root exclusivo del subdominio, aplicación y almacenamiento separados; verificar rutas físicas resueltas y enlaces.
- Solo public/ es público. Configuración, código privado, uploads, logs, secretos y backups fuera de esa raíz.
- Base de datos y usuario de base exclusivos con privilegios mínimos. No usar la cuenta raíz de BD ni tablas del sitio principal.
- En VPS: servicio/proceso y virtual host propios. En hosting compartido: carpeta, configuración y permisos específicos del subdominio. Un subdominio solo NO garantiza aislamiento de procesos; comprobar límites reales de la cuenta.
- HTTPS con certificado válido para el hostname final, renovación y hostname verificados. No desactivar validación TLS desde Flutter.
- FTPS/SFTP sirven para administración/transferencia cuando el hosting los soporte; la app usa HTTPS/API, nunca credenciales FTP. No desplegar con FTP sin cifrado.

## Servidor confirmado: PHP
PHP es el lenguaje elegido por el usuario. Verificar versión soportada, PDO y driver de BD, librería de imágenes, límites de upload/memoria/ejecución y cron o PHP CLI. No cambiar de lenguaje para resolver un límite sin autorización. Diseño concreto en 22_SERVIDOR_PHP.md.

BD remota confirmada: MariaDB, con base/usuario exclusivos del sistema. SQLite móvil es almacenamiento limitado de continuidad, no copia completa ni base central. El sitio público no permite deducir panel, configuración o capacidad de workers. No se ha verificado configuración privada del hosting.

## Secuencia de instalación
1. Inventariar acceso y capacidades, sin mostrar secretos. Confirmar nombre y document root exclusivo.
2. Preparar proyecto y variables locales de ejemplo; secretos reales en gestor de entorno fuera de Git/agent.
3. Preparar BD nueva y migraciones en entorno de prueba; documentar propuesta antes de aplicar al entorno real.
4. Preparar carpeta/API del subdominio y certificado. No sobrescribir contenido existente.
5. Probar auth, lectura NFC/QR, archivo permitido/rechazado, consultas y reporte con datos ficticios.
6. Preparar plan de despliegue y reversión; obtener aprobación para acciones de núcleo/infraestructura real según 05_CAMBIOS.md.
7. Verificar que el sitio raíz conserva archivos, rutas y funcionamiento; comparar alcance/diff sin incluir secretos.

No generar una configuración ejecutable de servidor basada en una IP, panel o ruta inventados. Documentar valores pendientes; no afirmar despliegue activo.
