# DOC-NEXLABS-001 — contexto de sistema NFC/QR

- Fecha: 2026-10-11, America/Lima.
- Versión: Unreleased; app prevista 0.0.0. Cambio documental, sin ID visual/funcional de código.
- Estado: documentación implementada y estructura verificada. Sin app/servidor activos.
- Solicitud: incorporar dominio Nexlabs, subdominio exclusivo, NFC/QR, BD de alumnos/lugares/registros, fotos y protección de archivos.
- Problema anterior: kit genérico sin entidades, política de campos ni despliegue específico.
- Razonamiento: separar identificación de autorización, limitar proyección QR en API, definir esquema relacionado y aislar el sistema del sitio existente. PHP confirmado por el usuario; MariaDB central confirmada; versiones/capacidades aún pendientes. SQLite/outbox y dos pasadas a 5 segundos completan el diseño de continuidad.
- Antes: propósito de app pendiente; servidor genérico.
- Después: alcance confirmado y ocho guías específicas, con propuestas y pendientes separados. Lectura y registro no se confunden; no se inventa asistencia ni acceso físico.
- Archivos: 04_PRODUCTO, 00_INDEX, ESTADO, PROMPT y README; ampliados 01_REGLAS, 03_DISENO, 09_SERVIDOR; agregados 12 a 19 y este detalle; actualizado CHANGELOG.
- Dependencias: tarjetas reales, reglas del evento, roles/campos, hosting y subdominio aún pendientes.
- Referencia previa: snapshot ZIP previo fuera de la carpeta principal, ruta ../backups/kit_antes_nexlabs/Kit_Agent_Flutter.zip desde kit_agente.
- SHA-256 previo: 1fcacd41d5ea1319bf37ae2f359d910c21c87c58b38a0678d0448d3579c86c06.
- Referencia del cambio: diff documental changes/DOC-NEXLABS-001.patch.md. No hay commit Git; no inventar uno.
- Aprobación: solicitud explícita del usuario para actualizar contexto. No se activan permisos ni se modifica núcleo, BD o infraestructura real.
- Pruebas: integridad ZIP, resolución de referencias Markdown y coincidencia de snapshot previo; ningún test de app/API ejecutado.
- Riesgos: NFC estático no demuestra autenticidad; campos/stack aún no confirmados; subdominio no existe por efecto de este documento.
- Reversión documental: cerrar edición, aplicar inverso del diff únicamente a archivos afectados, revisar posibles cambios posteriores y registrar la reversión. También se puede extraer el snapshot a carpeta hermana y comparar sin sobrescribir el árbol actual.
- Reversión lógica real: no aplica, no hubo código ni datos de app cambiados. Futuras modificaciones tendrán su entrada con commit/migración y pruebas de recuperación.
- Criterio de recuperación: documentos vuelven a la versión anterior si se requiere, conservando cualquier trabajo posterior y la decisión del usuario sobre no tocar el dominio raíz.

## Aclaración PHP y SQLite incorporada en esta entrega
Antes: alternativas de lenguaje y cola offline sin definición. Después: PHP confirmado; SQLite como cache/outbox; intervalo 5 segundos, primer fallo al final de ronda, segundo fallo a revisión manual. Nuevo diseño en 20 a 22 y reglas coherentes en producto/API/plan/pruebas. Solicitud explícita del usuario; sin mutaciones de app/servidor real. El diff de la entrega incluye esta aclaración; snapshot previo permanece sin cambios.

## Aclaración MariaDB y datos locales incorporada
MariaDB central confirmada. SQLite conserva un conjunto útil parcial para mostrar información conocida, no toda la base; se añade política de precarga, campos mínimos, fotos privadas, cursor por ámbito y estado de frescura. Antes: motor central pendiente/caché genérica. Después: MariaDB + SQLite parcial usable. No se ha aplicado migración ni descargado datos reales.
