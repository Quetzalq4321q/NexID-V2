# Decisiones Arquitectonicas Consolidadas (`DECISIONS.md`)

1. **PRIORIDAD 0 (Rendimiento en Gama Baja 2-4 GB RAM y Adaptacion Automatica)**:
   - Toda decision visual o funcional se subordina a la fluidez en equipos economicos (Samsung Galaxy A13, Galaxy A14, Xiaomi Redmi 15C).
   - La aplicacion consulta directamente la telemetria nativa de Android (`DeviceCapabilitiesManager.kt` -> `DeviceCapabilitiesSnapshot`) y adapta su perfil automaticamente (`isAutoPerformance = true`) sin obligar al usuario normal a elegir manualmente la RAM de su telefono.
   - La sobreescritura manual de perfiles (`2 GB`, `3 GB`, `4 GB`, `Adverso`) se aisla en **Configuracion avanzada** protegida por permisos reales de Administrador (`SessionController.canAccessAdvancedSettings`) y jamas altera los datos reales reportados por el hardware.
2. **Diseno Visual Definitivo de Configuracion (`SettingsPage` `v0.0.9+9`)**:
   - Estructura vertical limpia: Encabezado (`SettingsHeaderBar`), barra de busqueda (`Buscar un ajuste...`), tarjeta destacada `Optimizacion del dispositivo` (`DeviceOptimizationBannerCard` conectada a `isDetectionCompleted`) y lista vertical de 8 categorias (`SettingsSectionId.publicSections`) con navegacion dedicada por subpantalla sin sobrecargar la vista principal.
3. **Arquitectura Feature-First Anti-Monolitos**:
   - Limite estricto de `< 250 lineas` por archivo `.dart` y `< 40 lineas` por funcion.
   - Separacion limpia entre `domain`, `data` y `presentation` con inyeccion por `AppDependencies` (`InheritedWidget`) y `ChangeNotifier`.
4. **Independencia Total de Temas (`NexIdPalette`) y Tonos Neutros/Azules**:
   - Cuatro paletas semanticas (`light`, `lightHighContrast`, `dark`, `darkHighContrast`) inyectadas por `ThemeExtension<NexIdPalette>` usando tonos neutros y variantes azules (sin acentos morados). Cero colores estaticos en vistas (salvo la hoja de papel A4 en `PdfA4SheetWidget`).
5. **Puente Nativo Kotlin Puro (`MainActivity.kt` y `DeviceCapabilitiesManager.kt`)**:
   - Cero Java en la capa Android de la aplicacion. Lectura fisica NFC mediante `NfcAdapter.enableReaderMode`, escaneo QR por camara y telemetria de hardware/SO (`ActivityManager`, `PowerManager`, `StatFs`, `ConnectivityManager`) en Kotlin.
6. **Persistencia Local y Cola de 5 Segundos (`agent/20_SQLITE_LOCAL.md` y `agent/21_COLA_5_SEGUNDOS.md`)**:
   - La app opera en modo 100% local hasta que el usuario autorice la conexion con el backend PHP/MariaDB en el subdominio de `nexlabs.net.pe`.
   - La limpieza de memoria RAM (`DeviceMemoryGuard.evictTransientMemory()`) jamas toca los registros pendientes de sincronizacion (`outbox`).
