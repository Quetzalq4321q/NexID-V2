# Mision: Deteccion Real de Hardware, Diseno Visual Definitivo de Configuracion y Ajustes Avanzados (`v0.0.9+9`)

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
  - `SettingsController.isDetectionCompleted` y `optimizationStatusLabel` garantizan que la tarjeta de optimizacion muestre `Verificando capacidades...` antes de finalizar la deteccion y `Estado: Automatica` una vez confirmada.

## 2. Perfil Automatico e Inteligente por Defecto (`isAutoPerformance = true`)
- El usuario normal **no** elige manualmente entre `2 GB`, `3 GB` o `4 GB` de RAM.
- `DevicePerformanceProfile.resolveAutomaticProfile(snapshot, memoryPressureEvents)` determina automaticamente el nivel interno (`AdaptivePerformanceLevel.lightweight`, `balanced` o `full`) evaluando restricciones reales de memoria, heap del proceso, ahorro de bateria, estado termico y eventos de presion de memoria.
- Si el sistema operativo emite `didHaveMemoryPressure()`, `SettingsController.onRuntimeMemoryPressure()` degrada automaticamente el perfil activo para proteger la estabilidad.

## 3. Estructura Visual Definitiva de Configuracion (`SettingsPage` y `device_optimization_banner.dart`)
- **Encabezado (`SettingsHeaderBar`)**:
  - Flecha de regreso (`Icons.arrow_back`, `Key('settings_back_button')`), titulo **«Configuracion»** e icono de ajustes alineado a la derecha (`Icons.settings_outlined`, `Key('settings_header_icon')`).
- **Barra de Busqueda (`Key('settings_search_input')`)**:
  - Bordes redondeados (`10.0`), icono de lupa y texto `Buscar un ajuste...`. Filtra las opciones en tiempo real mediante `SettingsSearchCatalog` y navega directamente al apartado correspondiente al pulsar cualquier coincidencia.
- **Tarjeta Destacada de Optimizacion (`DeviceOptimizationBannerCard`)**:
  - Titulo: **«Optimizacion del dispositivo»**
  - Estado conectado a la deteccion real: `Estado: Automatica` (o `Manual (...)` / `Verificando capacidades...`).
  - Descripcion: `«El sistema adapta el consumo de recursos segun las capacidades y condiciones del dispositivo»`.
  - Franja inferior: `Gestion de rendimiento: <nivel activo> · <resumen de hardware>`.
- **Lista Vertical Ordenada de 8 Categorias (`SettingsCategoryListTile` / `SettingsSectionId.publicSections`)**:
  1. **Apariencia y personalizacion** — `Tema, estilo y visualizacion.` (`ThemeAppearanceCard`).
  2. **Accesibilidad** — `Texto, contraste y movimiento.` (`AccessibilityControlsCard`).
  3. **Rendimiento** — `Optimizacion automatica.` (`LowEndPerformanceCard`).
  4. **Almacenamiento y cache** — `Archivos temporales y espacio.` (`StorageAndCacheCard`).
  5. **Conectividad y sincronizacion** — `Estado de conexion y datos.` (`ConnectivitySyncSettingsCard`).
  6. **NFC y registros** — `Lector, validacion y actividad.` (`NfcAndRecordsSettingsCard`).
  7. **Privacidad y seguridad** — `Proteccion y sesion.` (`PrivacySecuritySettingsCard`).
  8. **Acerca de la aplicacion** — `Version y soporte.` (`AppHardwareInfoCard`).
- **Navegacion Dedicada y Configuracion Avanzada Oculta (`SettingsSectionId.advanced`)**:
  - Cada categoria abre su propia vista interna sin acumular todos los controles en una sola pantalla.
  - La seccion de **Configuracion avanzada** no aparece en la lista publica de 8 categorias; se accede desde el icono de ajustes del encabezado o desde `Acerca de la aplicacion`, y permanece restringida a `UserRole.administrador` (`SessionController.canAccessAdvancedSettings`).
