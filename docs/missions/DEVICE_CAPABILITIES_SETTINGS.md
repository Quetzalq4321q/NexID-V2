# Mision: Deteccion Real de Hardware, Adaptacion Inteligente y Ajustes Avanzados (`v0.0.8+8`)

## 1. Deteccion Nativa de Capacidades del Dispositivo (`DeviceCapabilitiesManager.kt` y `DeviceCapabilitiesSnapshot`)
- **Canal Nativo Kotlin (`com.nexlabs.nexid/hardware` -> `getDeviceCapabilities`)**:
  - `ActivityManager.MemoryInfo`: `totalRamMb`, `availableRamMb`, `lowMemoryThresholdMb`, `isSystemLowMemory`, `isLowRamDevice`, `memoryClassMb`, `largeMemoryClassMb`.
  - `Runtime.getRuntime()`: `processMaxHeapMb`, `processAllocatedHeapMb`, `processorCores`.
  - `Build`: `cpuArchitecture` (`SUPPORTED_ABIS`), `hardwareBoard` (`SOC_MODEL` / `HARDWARE`), `androidRelease`, `androidSdkInt`.
  - `StatFs`: `totalStorageMb`, `availableStorageMb`.
  - `PackageManager` y `DeviceConfigurationInfo`: `openGlEsVersion`, `supportsVulkanHardware`, `hasNfcHardware`.
  - `NfcAdapter`: `isNfcEnabled`.
  - `PowerManager` y `BatteryManager`: `isPowerSaveMode`, `batteryPercentage`, `thermalStatus` (API 29+).
  - `ConnectivityManager`: `hasActiveNetwork`, `connectionType` (`wifi`, `cellular`, `ethernet`, `none`), `isMeteredNetwork`.
- **Regla de Honestidad de Telemetria**:
  - Si Android o un entorno de pruebas no expone un dato, el campo permanece `null` (`No reportada por el SO`). Jamas se inventan cifras ni se deduce el rendimiento por el nombre comercial del telefono.
  - Las capacidades estaticas se cachean una sola vez por sesion; los indicadores dinamicos se consultan bajo demanda sin bloquear el hilo principal.

## 2. Perfil Automatico e Inteligente por Defecto (`isAutoPerformance = true`)
- El usuario normal **no** elige manualmente entre `2 GB`, `3 GB` o `4 GB` de RAM.
- `DevicePerformanceProfile.resolveAutomaticProfile(snapshot, memoryPressureEvents)` determina automaticamente el nivel interno (`AdaptivePerformanceLevel.lightweight`, `balanced` o `full`) evaluando restricciones reales de memoria, heap del proceso, ahorro de bateria, estado termico y eventos de presion de memoria.
- Si el sistema operativo emite `didHaveMemoryPressure()`, `SettingsController.onRuntimeMemoryPressure()` degrada automaticamente el perfil activo para proteger la estabilidad.

## 3. Reorganizacion Completa de Ajustes y Buscador Local (`SettingsPage`)
- **Buscador Superior (`Key('settings_search_input')`)**:
  - Indice local en `SettingsSearchCatalog` que filtra opciones en tiempo real por titulo, subtitulo, seccion y palabras clave.
  - Muestra a que seccion pertenece cada coincidencia y oculta las opciones restringidas cuando el usuario no tiene autorizacion de Administrador.
- **10 Secciones Estructuradas**:
  1. `Apariencia y personalizacion` (Tema Claro/Oscuro/Automatico y densidad visual compacta).
  2. `Accesibilidad` (Escala tipografica 90%-130%, alto contraste WCAG 2.2, reducir animaciones y lector de pantalla).
  3. `Rendimiento` (Estado de optimizacion automatica activa, nivel adaptativo detectado, modo reducido y ahorro de datos).
  4. `Almacenamiento y cache` (Presupuesto LRU de imagenes y fichas, espacio libre, cola SQLite protegida y limpieza temporal segura).
  5. `Conectividad y sincronizacion` (Red activa detectada, cola automatica de 5s y boton de sincronizacion manual).
  6. `NFC y registros` (Compatibilidad y estado del lector NFC, medio preferido NFC/QR, vibracion, sonido y guia de validacion en 2 pasadas).
  7. `Notificaciones` (Alertas operativas de lectura y avisos de cola pendiente).
  8. `Privacidad y seguridad` (Operador activo, rol, aislamiento de cache y politicas protegidas inmutables).
  9. `Informacion de la aplicacion` (Version instalada `v0.0.8+8`, resumen de hardware real detectado y estado operativo).
  10. `Configuracion avanzada` (Restringida a `UserRole.administrador` o autorizacion verificada en `SessionController.authorizeDiagnosticSession`; permite elegir manualmente el nivel/perfil de rendimiento sin falsificar los datos reales de hardware y restaurar el modo automatico recomendado).
