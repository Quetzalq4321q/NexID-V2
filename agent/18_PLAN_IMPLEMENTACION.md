# Orden de implementación

## Incrementos
1. Cerrar pendientes de 04_PRODUCTO.md, versión/capacidades PHP y tarjetas de prueba. Decisiones en Markdown breve; no pedir otra vez datos ya confirmados.
2. Generar Flutter Android y servidor PHP modular locales, composición y diseño compartido. Integrar SQLite/cola persistente y contrato idempotente antes de enviar cargas reales. Versión inicial 0.0.0; pruebas con datos ficticios.
3. Proponer auth, matriz de permisos, esquema relacional y migraciones. Obtener aprobación previa al activar núcleo/datos/permisos del entorno real según 05_CAMBIOS.md.
4. Implementar resolución de credenciales con proyección full/partial y revocación; primero fake adapters/API en pruebas, luego tarjeta/cámara reales.
5. Implementar alumnos/lugares/foto y validación server-side. Confirmar dónde se editan datos antes de construir administración.
6. Implementar significado aprobado de registros, transacción e idempotencia. No adelantar asistencia o acceso físico sin reglas.
7. Agregar importaciones y reportes por jobs según frecuencia real; no desplegar servicios que el hosting no soporte.
8. Pruebas integradas, autorización de despliegue al subdominio aislado, restauración ensayada y verificación del sitio principal intacto.

## Evidencia por incremento
ID visual/funcional + versión numérica de entrega; problema; decisión; lógica antes/después; archivos/commit; tests reales; riesgos; aprobación; backup si aplica; reversión de código/datos. No afirmar activo hasta ejecutar y verificar en el entorno acordado.

## Primer siguiente paso
Confirmar tipo de NFC y contenido actual, significado del registro y capacidades del hosting. La documentación puede avanzar; no escribir integraciones de tarjetas o despliegues basados en supuestos.

## Prioridad confirmada
PHP + SQLite/cola idempotente forman el incremento de continuidad. Probar dos pasadas, intervalo 5 segundos, servidor saturado y timeout tras commit antes de habilitar cargas reales. MariaDB central y PHP ya están confirmados. Siguen pendientes sus versiones/capacidades y soporte de cron.
