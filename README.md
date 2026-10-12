# NexID - Sistema de Control y Credenciales NFC y QR (Android Flutter)

Sistema cliente móvil para Android desarrollado en **Flutter (Dart y Kotlin)** para la gestión y lectura de credenciales mediante tecnología **NFC** y códigos **QR**, con sincronización local y políticas de proyección de datos seguras.

---

## 1. Alcance y Modo de Operación Actual

- **Modo 100% Local:** Todo el funcionamiento actual se ejecuta localmente en la aplicación móvil con datos y servicios simulados de alta fidelidad, **sin requerir backend PHP ni base de datos MariaDB activa en esta fase**.
- **Lenguajes Autorizados:** **Dart** para todas las interfaces y controladores de la aplicación móvil; **Kotlin** para la capa nativa Android (`MainActivity.kt`). Queda expresamente evitado el uso de Java a nivel de la app.
- **Sin Monolitos:** Estructura modular estricta por funcionalidades (`features/<modulo>`), donde cada archivo tiene una única responsabilidad y se mantiene por debajo de 250 líneas.

---

## 2. Permisos Google Android para NFC y Hardware

En estricto cumplimiento de las guías oficiales de Google Android y `agent/13_NFC_QR.md`, se encuentran declarados en `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Permiso principal de Google para lectura NFC -->
<uses-permission android:name="android.permission.NFC" />

<!-- Permisos de conexion de red y camara para escaneo QR -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />

<!-- Declaracion de hardware opcional para permitir instalacion en dispositivos sin NFC -->
<uses-feature android:name="android.hardware.nfc" android:required="false" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

> **Nota:** La declaración de `android.hardware.nfc` con `android:required="false"` permite que la aplicación continúe disponible e instalable en dispositivos que no cuentan con chip NFC, permitiéndoles operar bajo la modalidad de lectura QR.

---

## 3. Arquitectura Modular

Organizada según las especificaciones de `agent/02_ARQUITECTURA.md`:

```
lib/
├── main.dart                          # Arranque minimo de la aplicacion
├── app/
│   ├── app.dart                       # Composicion raiz y control de sesion
│   ├── app_shell.dart                 # Contenedor de navegacion adaptable
│   ├── app_dependencies.dart          # Inyeccion de dependencias desacoplada
│   └── app_theme.dart                 # Tema oficial segun BRANDING.md
├── core/
│   ├── constants/                     # Tokens oficiales de color, tipografia y dimensiones
│   └── responsive/                    # Constructor adaptativo (<600, 600-839, >=840 px)
├── shared/
│   ├── widgets/                       # Botones accesibles de 48px, badges, placeholders
│   └── utils/                         # Formateo de fechas y validadores
└── features/
    ├── session/                       # Pantalla 1: Acceso, operadores y roles
    ├── places/                        # Selector y catalogo de puntos de control
    ├── reading/                       # Pantalla 2: Coordinador de lectura NFC y QR
    ├── students/                      # Pantallas 3 y 5: Ficha de alumno y edicion
    ├── records/                       # Pantalla 4: Historial de registros y filtros
    ├── uploads/                       # Subida segura de fotos con validacion (<2MB)
    ├── reports/                       # Pantalla 6: Trabajos de reportes asincronos
    └── sync/                          # Banner y coordinador de cola outbox (5s)
```

---

## 4. Modulos y Pantallas Implementadas

1. **Acceso y Sesión (`session`):** Autenticación de operador con selección de perfiles de prueba para alternar entre roles (Operador, Administrador, Solo Lectura).
2. **Puntos de Control (`places`):** Selección del lugar operativo (Puerta Principal, Biblioteca Central, etc.).
3. **Lectura NFC y QR (`reading`):**
   - **Lectura NFC:** Resuelve la **Ficha Completa Autorizada** con todos los datos académicos y documento de identidad.
   - **Lectura QR:** Resuelve la **Proyección Parcial**, ocultando datos sensibles por política del servidor.
   - Incluye selector de fichas de prueba locales para validación inmediata en Android Studio.
4. **Ficha de Alumno (`students`):** Visualización del alumno con banner distintivo de modalidad y acciones directas para "Registrar Ingreso" y "Registrar Salida".
5. **Historial de Registros (`records`):** Lista filtrada por estado de sincronización (*Pendiente de enviar*, *Confirmado por servidor*, *Requiere revisión*).
6. **Subida Segura de Archivos (`uploads`):** Validación estricta UX por tipo (JPG/PNG) y peso (<2MB) con barra de progreso.
7. **Reportes en Segundo Plano (`reports`):** Solicitud y seguimiento asíncrono de reportes (PDF/CSV) sin bloquear la interfaz.
8. **Coordinador de Sincronización (`sync`):** Simulación de cola Outbox con intervalo de 5 segundos y política de dos pasadas.

---

## 5. Identidad Visual y Branding

Consulte el archivo dedicado [`BRANDING.md`](file:///c:/Users/User/StudioProjects/NexID/BRANDING.md) para conocer la paleta oficial (Azul `#1D4ED8`, Morado superficie `#DDD6FE`, Roboto, controles de 48 px y prohibición total de emojis).

---

## 6. Instrucciones de Ejecución en Android Studio

1. Abra la carpeta del proyecto `c:\Users\User\StudioProjects\NexID` en **Android Studio**.
2. Abra una terminal o utilice las herramientas integradas y ejecute:
   ```bash
   flutter pub get
   flutter test
   ```
3. Seleccione un emulador Android o dispositivo físico conectado y presione **Run** (`Shift + F10`) o ejecute:
   ```bash
   flutter run
   ```

---

## 7. Historial de Cambios y Versionado

Consulte el registro global en [`CHANGELOG.md`](file:///c:/Users/User/StudioProjects/NexID/CHANGELOG.md) para revisar el historial trazable de cambios (`VIS-x`, `FUN-x`) y el cumplimiento de las normas de versionado.

