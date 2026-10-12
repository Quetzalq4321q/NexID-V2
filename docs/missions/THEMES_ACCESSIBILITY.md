# Mision: Independencia de Temas Claro/Oscuro y Accesibilidad WCAG 2.2 (`PRIORIDAD 3`)

## 1. Tokens Semanticos (`lib/core/theme/nexid_palette.dart`)
- `NexIdPalette` (`ThemeExtension<NexIdPalette>`) provee cuatro paletas independientes: `light`, `lightHighContrast`, `dark` y `darkHighContrast`.
- **Paleta institucional en tonos neutros y variantes azules (cero acentos morados)**:
  - `surfaceAccent` utiliza azul institucional suave (`0xFFEFF6FF` / `0xFFDBEAFE` en modo Claro y `0xFF172554` / `0xFF1E3A8A` en modo Oscuro) para contenedores de iconos y tarjetas destacadas en `Configuracion`.
- **Regla estricta**: Ningun widget de interfaz debe usar `Colors.white`, `Colors.black` o `AppColors` directamente, salvo el lienzo de impresion fisica A4 (`PdfA4SheetWidget`) que representa papel blanco impreso.

## 2. Selector de Apariencia y Deteccion del SO (`ThemeAppearanceCard`)
- Accesible en la primera categoria de `Configuracion` (**Apariencia y personalizacion**).
- Detecta `MediaQuery.platformBrightnessOf(context)` en tiempo real e incluye las opciones **Claro**, **Oscuro** y **Automatico** junto con densidad visual compacta.

## 3. Controles WCAG 2.2 y Sincronia con Prioridad 0
- **Escala de fuente**: `90%`, `100%`, `115%` y `130%`.
- **Alto contraste**: Bordes reforzados y `boldText`.
- **Reduccion de movimiento (`effectiveReduceMotion`)**: Se activa cuando el usuario marca `Reducir movimiento` o cuando esta activo el `Modo de rendimiento reducido (Prioridad 0)`, reemplazando el barrido `ShimmerBox` por placeholders estaticos de cero coste de CPU.
