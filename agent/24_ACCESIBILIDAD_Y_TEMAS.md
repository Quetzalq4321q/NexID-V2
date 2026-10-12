# 24. Accesibilidad WCAG 2.2, Temas Independientes, Skeletons y Vista Previa PDF A4

## 1. Tokens Semánticos y Separación Claro/Oscuro
- `NexIdPalette` (`lib/core/theme/nexid_palette.dart`) define cuatro variantes independientes: `light`, `lightHighContrast`, `dark` y `darkHighContrast`.
- Todo widget de interfaz debe resolver sus colores mediante `NexIdPalette.of(context)`.
- Ningún cambio en el modo oscuro debe alterar los tokens del modo claro ni viceversa.

## 2. Detección Automática del Sistema Operativo
- `ThemeAppearanceCard` (`lib/features/settings/presentation/widgets/theme_appearance_card.dart`) inspecciona `MediaQuery.platformBrightnessOf(context)` e informa si el sistema operativo está en modo claro u oscuro.
- Ofrece tres opciones persistentes en sesión: `Claro`, `Oscuro` y `Automático`.

## 3. Sistema Global de Skeleton Loading
- `ShimmerBox` y `DataStateBoundary` (`lib/shared/widgets/skeleton/shimmer_skeleton.dart`) gestionan los estados de carga inicial, actualización sobre caché, vacío y error con opción de reintento.
- Si `reduceMotion` está activo, `ShimmerBox` desactiva su `AnimationController` y muestra un bloque estático de alto contraste.

## 4. Módulos Enriquecidos de Alumnos y Registros
- **Alumnos**: KPIs superiores, filtros por estado académico, búsqueda multicriterio y expediente dividido en 3 pestañas (`Personal`, `Académico`, `Seguimiento`) con datos de demostración claramente identificados (`[Demo]`).
- **Registros**: KPIs en tiempo real, búsqueda por ID/alumno/operador/punto, desplegable unificado, paginación progresiva (`pageSize = 6`) y hoja modal `RecordDetailSheet` con línea de tiempo de auditoría.

## 5. Vista Previa de Documentos PDF en Formato A4
- `PdfPreviewPage` (`lib/features/reports/presentation/pages/pdf_preview_page.dart`) permite previsualizar antes de emitir tanto la **Ficha Institucional de Alumno** como el **Reporte General de Registros**, incluyendo encabezado institucional, logo geométrico, tablas ordenadas, KPIs, fecha de emisión y numeración de páginas (`Página 1 de 1`).
