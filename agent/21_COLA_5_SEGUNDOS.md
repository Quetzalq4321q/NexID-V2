# Cola persistente: dos pasadas y revisión manual

## Regla solicitada
Las cargas esperan intervalos de 5 segundos; si no son aceptadas pasan al final, se prueban nuevamente y si fallan se solicita revisión manual. Interpretación explícita: primer intento + un reintento final por operación. No significa enviar cada carga dos veces si ya fue aceptada.

## Despachador
- Cola en SQLite, un despachador y como punto inicial una carga en vuelo por dispositivo/sesión.
- Mínimo 5 segundos entre INICIOS de envíos consecutivos. Si un envío dura más, no solapar. Tras timeout respetar igualmente el siguiente instante elegible; no repetir de inmediato.
- Si Retry-After exige más, esperar max(5 segundos, Retry-After); no saturar el servidor por forzar 5 segundos exactos. Sin red conocida o circuito de servidor pausado: esperar, no consumir intentos de toda la cola.
- Antes de enviar, guardar intento/lease/estado durable. No busy-loop ni sleep bloqueante en UI/handler PHP.
- Una ronda usa snapshot finito de operaciones elegibles. Nuevas llegadas esperan siguiente ronda; no impedir para siempre la pasada final de fallidos. Dependencias listas antes de enviar; preservar orden lógico.
- Primera pasada: cada carga elegible una vez. No aceptada por error recuperable -> deferred, al final de esa ronda, mismo operation_id/clave/payload.
- Al terminar primera pasada, segundo intento de deferred, respetando 5 segundos. Segundo fallo de envío recuperable -> manual_review. No tercer intento automático.

## Resultado del servidor
| Resultado | Tratamiento |
|---|---|
| 200/201 con confirmación válida del mismo operation_id | Confirmed; actualizar ID/estado local, no repetir |
| 202 con job/operation_id durable | Accepted, esperar resultado/consultar estado; no reenviar el trabajo |
| Timeout/respuesta perdida | Resultado incierto; consultar estado por ID o reenviar con misma clave idempotente en pasada final |
| 429/503/transitorio no aceptado | Deferred con instante elegible y pasada final |
| 401 | Pausar para recuperar sesión una vez; no disparar cola con otro usuario |
| 403/413/415/422 permanente | Revisión manual inmediata con motivo; no repetir payload inválido sin cambios |
| 409 | Conciliar si es conflicto de idempotencia/concurrencia; no tratar automáticamente como éxito |
| Sin conexión local comprobada | Pending; no gastar intentos ni afirmar rechazo del servidor |

Si PHP aceptó duraderamente el job pero este falla después, informar revisión del job; no hacer un POST duplicado desde la app. Reintentos del worker son una política aparte, delimitada; no combinar dos mecanismos de retries que multipliquen intentos.

## Idempotencia y resultado incierto
- operation_id estable generado ANTES de guardar local; servidor con restricción única por actor/ámbito + idempotency key + hash del payload.
- Misma clave/cuerpo devuelve el resultado previo; misma clave/cuerpo distinto -> conflicto. Cambiar datos exige nueva operación ligada a la anterior, después de comprobar que la anterior no se ejecutó.
- Guardar clave y efecto en la misma transacción remota. Se evita efecto duplicado, no se promete que la red entregue exactamente una vez.
- Endpoint de conciliación verifica autorización por operación. La retención de claves debe cubrir la retención/reintento de la cola; no expirar claves mientras existan pendientes que puedan repetirse.
- Si no hay resultado verificable tras segundo fallo, manual_review conserva datos y condición “resultado desconocido”; operador consulta antes de autorizar otro intento.

## Estados persistentes
Pending -> Sending -> Confirmed o Accepted. Sending no aceptado -> Deferred -> Sending (pasada final) -> Confirmed/Accepted o ManualReview. Accepted -> seguimiento de job -> Confirmed o ManualReview si falla. Sin red/pausa detiene transición; no borra la fila.

Revisión manual muestra motivo breve, fecha, intento, operation_id y acción “Revisar”. Operador autorizado puede conciliar, corregir o autorizar reintento puntual documentado. No envía automáticamente otra vez ni crea copia con ID nuevo para esconder el error.

## Saturación de ambos lados
Caché y deduplicación reducen lecturas. Intervalo limita cargas por dispositivo, NO tráfico total de todos los dispositivos. PHP necesita rate limit/cuotas por actor/instancia, rechazo controlado, idempotencia y worker con concurrencia acotada. No abrir conexión permanente por cada pendiente.

## Android
Intervalos de 5 segundos se aplican mientras el despachador puede ejecutarse. Un Timer no garantiza ejecución con app cerrada/Doze; usar mecanismo Android compatible si el negocio exige background. No prometer periodicidad exacta en segundo plano. Pending persiste y se retoma al volver sin perder orden, claves ni intentos.
