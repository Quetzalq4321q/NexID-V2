# Criterios de aceptación y pruebas

## Privacidad y permisos
- Usuario sin scope no obtiene ficha completa, foto, registro ni reporte de otro ámbito.
- QR limitado: verificar JSON/HTTP y caché, no solo pantalla. Campos excluidos nunca llegan en la respuesta.
- Manipular observed_source= nfc o fields=all no amplía credencial QR ni scope del operador.
- Credencial expirada/revocada no resuelve; respuestas no permiten enumerar alumnos.
- UID/token estático no se promociona como prueba fuerte de autenticidad.

## Lectura y dispositivos
- NFC compatible real, tarjeta desconocida, tecnología incompatible, NFC apagado, teléfono sin NFC, salida/reentrada de pantalla.
- QR válido, ajeno, corrupto, repetido y URL arbitraria; cámara rechazada/revocada.
- Callbacks repetidos no duplican consultas/eventos. Reanudar app no conserva captura activa incorrecta.
- Anchos compacto/medio/amplio, rotación, teclado, texto ampliado, lector de pantalla y controles claros.

## Datos y red
- Crear/editar alumno con validación, código duplicado y concurrencia.
- Registro con mismo Idempotency-Key se inserta una sola vez aun si la primera respuesta se pierde; cuerpo distinto con misma clave falla.
- Lugar ajeno, alumno inactivo, token revocado y evento no permitido se rechazan.
- Red lenta/desconectada/429/5xx: timeouts y reintentos limitados; no éxito ficticio ni reinicio completo.
- Listados paginados mantienen orden y aislamiento; no consultas sin límite.

## Archivos/reportes
Ejecutar casos de 16_ARCHIVOS.md. Reportes en cola/listo/fallido/cancelado según soporte, autorización de descarga y límites; jobs repetidos no generan carga ilimitada. Importación parcialmente inválida informa conteos y conserva trazabilidad.

## Hosting y reversión
Probar API/HTTPS en hostname elegido; BD y storage privados; raíz Nexlabs sin archivos/rutas alterados. Ensayar restauración en entorno aislado: código, esquema, datos, fotos y referencias consistentes. Verificar recuperación lógica con el caso original que falló, no solo comprobar que la app abre.

No se ejecutaron estas pruebas en esta entrega: solo se verificó el kit documental. No hay app/servidor desplegados.

## SQLite y cola de doble pasada
- Reiniciar app entre captura/envío/ACK conserva pendientes sin duplicar efecto.
- Ronda A,B,C: A falla primero; B,C avanzan; A se reintenta al final. A confirmado no tiene otro POST.
- Inicios de envío separados por >=5 segundos; petición lenta no produce solapamiento; Retry-After mayor se respeta.
- Segundo fallo -> manual_review; no tercer envío automático. Sin red comprobada no consume intentos de toda la cola.
- 202 durable inicia seguimiento de job y no vuelve a cargar el contenido. Respuesta de commit perdida se concilia por misma clave.
- Nuevas llegadas no retrasan para siempre la pasada final; dependencias de operaciones respetadas.
- Revocación/cambio de usuario bloquea scope anterior; QR no recibe caché full de NFC.
- Actualización de esquema conserva pendientes antiguos; almacenamiento lleno, SQLITE_BUSY y corrupción no borran datos automáticamente.
- Múltiples dispositivos: límites del servidor además de 5 segundos por app; worker sin duplicar jobs.
- App suspendida no promete Timer exacto; reanudar reconstruye estados e instantes elegibles.

## Caché suficiente
Verificar los casos de 23_CACHE_USABLE.md. Con red lenta la ficha local conocida aparece sin esperar HTTP; fecha/estado identifica origen. QR nunca hereda datos completos NFC. Sync paginada avanza cursor solo al persistir, reintento de página no duplica filas, revocación/usuario invalidan scope y actualización no pisa pendientes.
