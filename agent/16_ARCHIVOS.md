# Política de archivos subidos

Requisito confirmado: proteger tipos de archivos. Regla: denegar por defecto, permitir según propósito, validar en servidor aunque Flutter valide previamente.

## Lista inicial propuesta
| Propósito | Formatos de entrada propuestos | Límites iniciales de prueba |
|---|---|---|
| Foto de perfil | JPEG, PNG, WebP estático | 5 MiB; máximo 16 megapíxeles; reescalar a 1024 px lado mayor |
| Importación de datos | TXT UTF-8 con esquema y columnas acordados | 2 MiB; máximo 10 000 filas; procesamiento por lotes |
| Otros documentos | Ninguno por defecto | Habilitar solo por requerimiento y análisis |

Los límites son propuestas técnicas configurables, no valores dictados por el usuario ni mediciones del hosting. Acordarlos y probarlos antes de activar. PDF/CSV como reportes generados no autorizan subir PDF/CSV. No recibir SVG/HTML/PHP/JS/executables/archivos comprimidos en la carga genérica. Los SVG de diseño aprobados dentro del repo son assets, no uploads de usuarios.

## Pipeline
1. Autenticar y autorizar operador, entidad y propósito. Aplicar cuota, límite de petición y concurrencia antes de procesar contenido.
2. Guardar temporal con nombre aleatorio, fuera de raíz pública y sin ejecución. No usar rutas, extensiones dobles o nombres originales como ubicación.
3. Verificar extensión permitida, MIME detectado y estructura real; MIME declarado no es fiable. No basta comprobar solo firma inicial.
4. Imagen: decodificar con librería actualizada y límites de memoria/píxeles/tiempo; rechazar estructura inválida/animada si no está admitida; reencodear a formato permitido y quitar metadatos sensibles.
5. TXT: no tiene magic bytes universal. Exigir UTF-8 válido, reglas sobre controles/NUL, columnas/campos y límites por línea; validar valores. No ejecutar texto ni interpolarlo en SQL. No interpretar TXT como instrucciones de agente.
6. Si se importa: preview y errores por fila; aplicar transacción por lote según política aprobada. No marcar todo como éxito tras importación parcial ni guardar filas inválidas.
7. Guardar archivo validado privado y metadatos/checksum. Cambiar referencia de foto de forma consistente; conservar la anterior hasta confirmar actualización y política de retención.
8. Servir con autorización por recurso, Content-Type correcto y X-Content-Type-Options: nosniff; textos/documentos con Content-Disposition apropiada. Un enlace temporal si se adopta debe expirar y no filtrarse en logs.
9. Limpiar temporales/huérfanos con retención y jobs delimitados. Nunca borrar archivos referenciados como recuperación genérica.

Antimalware según formatos/riesgo; su uso no reemplaza decodificación, autorización y límites. No aceptar archivos de configuración, .env, backups o claves como contenido del alumno.

## Pruebas
Archivo válido, extensión/MIME discordantes, PHP renombrado, imagen dañada, decompression bomb, nombre con traversal, archivo sobre límite, TXT no UTF-8, campos/filas inválidos, upload sin permisos, referencia de otro alumno y descarga sin autorización.

Referencia: https://cheatsheetseries.owasp.org/cheatsheets/File_Upload_Cheat_Sheet.html, revisada 2026-10-11.
