# Decisiones Arquitectonicas Consolidadas (`DECISIONS.md`)

1. **PRIORIDAD 0 (Rendimiento en Gama Baja 2-4 GB RAM)**:
   - Toda decision visual o funcional se subordina a la fluidez en equipos economicos (Samsung Galaxy A13, Galaxy A14, Xiaomi Redmi 15C).
   - Se adopta `DevicePerformanceProfile` (`lib/core/performance/device_performance_tier.dart`) con limites duros de `ImageCache`, `BoundedLruCache` y `PriorityTaskScheduler`.
2. **Arquitectura Feature-First Anti-Monolitos**:
   - Limite estricto de `< 250 lineas` por archivo `.dart` y `< 40 lineas` por funcion.
   - Separacion limpia entre `domain`, `data` y `presentation` con inyeccion por `AppDependencies` (`InheritedWidget`) y `ChangeNotifier`.
3. **Independencia Total de Temas (`NexIdPalette`)**:
   - Cuatro paletas semanticas (`light`, `lightHighContrast`, `dark`, `darkHighContrast`) inyectadas por `ThemeExtension<NexIdPalette>`. Cero colores estaticos en vistas (salvo la hoja de papel A4 en `PdfA4SheetWidget`).
4. **Puente Nativo Kotlin Puro (`MainActivity.kt`)**:
   - Cero Java en la capa Android de la aplicacion. Lectura fisica NFC mediante `NfcAdapter.enableReaderMode` y escaneo QR por camara con permisos declarados en `AndroidManifest.xml`.
5. **Persistencia Local y Cola de 5 Segundos (`agent/20_SQLITE_LOCAL.md` y `agent/21_COLA_5_SEGUNDOS.md`)**:
   - La app opera en modo 100% local hasta que el usuario autorice la conexion con el backend PHP/MariaDB en el subdominio de `nexlabs.net.pe`.
   - La limpieza de memoria RAM (`DeviceMemoryGuard.evictTransientMemory()`) jamas toca los registros pendientes de sincronizacion (`outbox`).
