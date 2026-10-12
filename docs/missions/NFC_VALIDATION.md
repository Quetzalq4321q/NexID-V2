# Mision: Lectura Fisica NFC, Escaneo QR y Prioridad Critica (`PRIORIDAD 1`)

## 1. Puente Nativo Kotlin (`MainActivity.kt` y `HardwareBridge`)
- Canal `pe.net.nexlabs.nexid/hardware` en Kotlin puro (`NfcAdapter.enableReaderMode` para `NFC_A`, `NFC_B`, `NFC_F`, `NFC_V`, `IsoDep`, `Ndef` y `ActivityResultContracts` para camara QR).
- Declaracion de permisos en `AndroidManifest.xml`: `android.permission.NFC`, `android.permission.CAMERA`, `android.permission.VIBRATE` y `android.permission.INTERNET`.

## 2. Prioridad Critica de Ejecucion (`ReadingController`)
- Toda lectura y validacion (`simulateScan`) se ejecuta dentro de `PriorityTaskScheduler.instance.runCritical(...)` (`TaskPriority.critical`).
- Mientras se valida una tarjeta NFC, el planificador detiene el arranque de tareas de baja prioridad (como generacion de reportes PDF) para garantizar respuesta inmediata en puerta.
- Incluye filtro de deduplicacion temporal (`1200 ms`) para la misma combinacion `placeId + medium + token`, evitando registros duplicados por doble contacto accidental.

## 3. Politica de Proyeccion (`agent/13_NFC_QR.md`)
- **NFC**: Habilita `ProjectionLevel.full` (incluye DNI y facultad a operadores autorizados).
- **QR**: Restringe a `ProjectionLevel.partial` (oculta DNI y datos sensibles).
