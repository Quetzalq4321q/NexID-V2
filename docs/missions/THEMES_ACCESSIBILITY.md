# Mision: Independencia de Temas Claro/Oscuro y Accesibilidad WCAG 2.2 (`PRIORIDAD 3`)

## 1. Tokens Semanticos (`lib/core/theme/nexid_palette.dart`)
- `NexIdPalette` (`ThemeExtension<NexIdPalette>`) provee cuatro paletas independientes: `light`, `lightHighContrast`, `dark` y `darkHighContrast`.
- **Regla estricta**: Ningun widget de interfaz debe usar `Colors.white`, `Colors.black` o `AppColors` directamente, salvo el lienzo de impresion fisica A4 (`PdfA4SheetWidget`) que representa papel blanco impreso.

## 2. Selector de Apariencia y Deteccion del SO (`ThemeAppearanceCard`)
- Ubicado en la parte superior de `SettingsPage`.
- Detecta `MediaQuery.platformBrightnessOf(context)` en tiempo real e incluye las opciones **Claro**, **Oscuro** y **Automatico**.

## 3. Controles WCAG 2.2 y Sincronia con Prioridad 0
- **Escala de fuente**: `90%`, `100%`, `115%` y `130%`.
- **Alto contraste**: Bordes reforzados y `boldText`.
- **Reduccion de movimiento (`effectiveReduceMotion`)**: Se activa cuando el usuario marca `Reducir movimiento` o cuando esta activo el `Modo de rendimiento reducido (Prioridad 0)`, reemplazando el barrido `ShimmerBox` por placeholders estaticos de cero coste de CPU.
