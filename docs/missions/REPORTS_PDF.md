# Mision: Conservacion y Optimizacion de Reportes PDF A4 (`PRIORIDAD 6`)

## 1. Diseño Institucional A4 Conservado (`PdfA4SheetWidget` y `PdfA4SectionsWidget`)
- Lienzo con proporcion A4 (`maxWidth: 620`, papel `#FFFFFF` y tinta `#180F24` constante para fidelidad de impresion).
- Soporta dos plantillas institucionales:
  1. **Ficha Institucional de Alumno**: Encabezado oficial, logo geometrico NexID, folio, tabla de identificacion, indicadores KPI, cursos y observaciones.
  2. **Reporte General de Registros**: Resumen de sincronizacion y tabla auditable de eventos.

## 2. Optimizacion de Renderizado y CPU (`PdfPreviewPage` y `ReportsController`)
- `PdfPreviewPage` envuelve `PdfA4SheetWidget` en un `RepaintBoundary` para evitar repintar el documento durante el desplazamiento vertical.
- `ReportsController.requestReport` delega la preparacion y calculo de checksum del reporte a `PriorityTaskScheduler.instance.runCpuIntensive` en `TaskPriority.low` (mediante `Isolate.run`), impidiendo que la generacion de un PDF bloquee la lectura NFC o la navegacion.
- Verifica `_isDisposed` antes de notificar cambios para evitar fugas de memoria si el usuario abandona la pantalla.
