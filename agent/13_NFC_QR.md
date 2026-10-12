# Lectura NFC y QR

## Política de información
| Medio | Resultado previsto | Control |
|---|---|---|
| NFC | Ficha completa de los campos autorizados | Sesión, alcance y credencial vigente |
| QR | Ficha parcial o modalidad específica | Proyección de campos calculada por servidor |

El medio no concede privilegios por sí solo. Una credencial NFC normal o QR puede copiarse; UID o token estático no equivalen a autenticación fuerte ni prueban presencia física. No diseñar control de acceso de alta seguridad con un UID como única prueba. Si hace falta asegurar posesión de tarjeta, acordar tarjeta/protocolo criptográfico compatible.

## Contenido de credencial: propuesta
- Token opaco no predecible por medio, sin nombre, documento, foto ni contraseña. Versión de formato y tipo permitidos.
- Vinculación y revocación controladas por servidor. Token en tránsito por HTTPS y protegido en logs; token aleatorio almacenado como hash/verificador cuando el formato lo permita.
- UID existente: solo asociación identificadora con alcance limitado; no inventar secretos de una tarjeta.
- La clasificación del token se obtiene de BD. No confiar en source=nfc o mode=full enviado por la app para ampliar acceso.
- Si el mismo token NFC puede copiarse en QR, no hay manera fiable de distinguir el medio solo con la declaración del cliente. Usar credenciales separadas y no prometer prevención de clonación sin protocolo adecuado.
- QR no abre URLs arbitrarias. Aceptar solo formato/host/prefijo acordados; no ejecutar ni interpretar contenido como código.
- NDEF es una opción de interoperabilidad, no un requisito confirmado para tarjetas existentes. Leer tecnología/contenido real antes de elegir adaptador Flutter.

## Flujo
1. Operador autenticado elige NFC o QR; verificar capacidad/permisos.
2. Adaptador lee y valida tamaño/formato; detiene sesión de captura al salir de pantalla.
3. Repositorio solicita resolución al servidor. Una lectura en vuelo por credencial; proteger contra callbacks repetidos.
4. Servidor verifica sesión, scope, token, tipo registrado, vigencia y modalidad; devuelve únicamente campos permitidos.
5. Vista compartida renderiza el resultado recibido. No recibir ficha completa para ocultar campos solo en Flutter.
6. Registrar actividad solo si el flujo aprobado lo exige; operación separada e idempotente. No convertir lectura automáticamente en asistencia.

## Android
- NFC e INTERNET se declaran en manifiesto; NFC no usa el diálogo runtime de permisos peligrosos.
- Cámara para QR en vivo requiere consentimiento runtime y manejo de rechazo/revocación. No pedir micrófono, contactos o ubicación por defecto.
- Recomendar NFC como capacidad opcional para conservar QR en teléfonos sin NFC, pendiente del alcance final. Comprobar hardware y NFC desactivado.
- Selección de fotos/archivos: preferir picker del sistema sin permiso amplio de almacenamiento, según API/plugin elegidos.
- Reader mode dentro de la app es una opción; confirmar ciclo de vida, versión Android y API del plugin. Revisar documentación actual si se usan intents/app links.
- Cambios reales de manifiesto y del núcleo NFC/QR siguen 05_CAMBIOS.md; este archivo es una propuesta, no prueba de permisos ya instalados.

## Fallos observables
Sin NFC: ofrecer QR si está disponible. NFC apagado: acción de activar. Tarjeta incompatible, desconocida, revocada o expirada: mensaje concreto. Cámara rechazada: permitir volver sin bloqueo. Sin red: mostrar solo caché permitida con fecha/estado; guardar cargas admitidas como pendientes en SQLite. No inventar ficha actualizada ni registro confirmado; seguir 20_SQLITE_LOCAL.md. Token malformado: rechazar local y servidor. Datos incompletos: informar sin destruir el estado.

Referencias oficiales: https://developer.android.com/develop/connectivity/nfc/nfc y https://developer.android.com/reference/android/Manifest.permission. Revisadas 2026-10-11; verificar API/SDK al implementar.
