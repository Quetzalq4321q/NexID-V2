# Errores y recuperación

- Validar entradas y manejar estados inicial, carga, éxito, vacío y error en cada flujo que los necesite.
- Los errores esperados se traducen en mensajes breves y una acción concreta. Registrar diagnóstico sin secretos ni datos personales.
- No silenciar excepciones ni capturar todas para simular éxito. Relanzar con contexto cuando otra capa deba decidir; preservar stack trace.
- Reintentos limitados solo para operaciones idempotentes y errores transitorios. Nunca repetir pagos/escrituras sin garantía de idempotencia.
- Restablecer solo el estado afectado cuando sea seguro. No reiniciar toda la app, borrar datos ni cerrar sesiones automáticamente para esconder un fallo.

## Cola y latencia
En sincronización aplica 21_COLA_5_SEGUNDOS.md: no bucles ilimitados ni éxito falso. Persistir pendientes, resultado incierto y revisión manual; reintento idempotente. No sumar retries HTTP invisibles a la doble pasada.
