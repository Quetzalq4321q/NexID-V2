# Mision: Adaptabilidad Visual y Listas Diferidas (`PRIORIDAD 2`)

## 1. Puntos de Corte y Proporciones (`lib/core/responsive/responsive_layout.dart`)
- **Compacto (`< 600 px`, incluido soporte extremo `320 px`)**: Barra inferior `NavigationBar`, tarjetas apiladas verticalmente, botones de altura minima `48 px` y encabezados con `Flexible`/`Expanded` y `TextOverflow.ellipsis`.
- **Medio y Expandido (`>= 600 px`)**: `NavigationRail` lateral y contenedores centrados con restriccion de ancho maximo (`maxWidth: 640` en ajustes, `maxWidth: 620` en hoja A4).

## 2. Reglas Anti-Desbordamiento (`RenderFlex`)
- Todo texto dinamico dentro de un `Row` debe estar envuelto en `Expanded` o `Flexible`.
- Controles compuestos (como barras de filtros o selectores de plantillas PDF) deben emplear `Wrap` o `Column` compacta para soportar escalas tipograficas de accesibilidad de hasta `130%` sin desbordar en pantallas de `320 px` a `390 px`.

## 3. Construccion Diferida de Listas
- En `StudentsPage` y `RecordsPage` es obligatorio utilizar `ListView.separated` con `addAutomaticKeepAlives: false` y `addRepaintBoundaries: true`.
- Prohibido instanciar cientos de tarjetas dentro de un `Column` con `.map().toList()`.
