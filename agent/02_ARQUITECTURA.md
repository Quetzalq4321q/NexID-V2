# Arquitectura modular

- Prohibidos los monolitos. Organizar por funcionalidad en features/<modulo>.
- Cada archivo tiene una responsabilidad. UI en presentation; servicios y repositorios en data. Dominio en domain únicamente cuando haya reglas de negocio reales.
- Las vistas no acceden a HTTP, almacenamiento ni permisos. Los controladores coordinan casos de uso/repositorios mediante inyección por constructor.
- main.dart solo inicia la app. app/ compone navegación, dependencias y tema. core/ contiene infraestructura transversal, nunca funciones del negocio.
- Una función reutilizada más de tres veces (desde la cuarta aparición) debe tener una única implementación en utils/<nombre_descriptivo>.dart. Si es específica de un módulo, usar sus utils; si realmente es transversal, shared/utils. No crear un utils.dart gigante. No extraer funciones diferentes solo porque se parecen.
- Widgets repetidos van en shared/widgets o widgets del módulo, no en utils. Mantener una sola implementación por componente visual; usar variantes explícitas para diferencias reales. Interfaces Dart representan contratos funcionales, no estilos visuales.
- Evitar dependencias circulares. Una funcionalidad no importa la implementación interna de otra.
- Objetivo orientativo: archivos menores de 250 líneas y funciones menores de 40. Si se supera, revisar responsabilidades; no dividir artificialmente para cumplir números.

## Mapa de carpetas de la app
- lib/main.dart: arranque mínimo.
- lib/app/: composición, rutas, tema e inyección.
- lib/core/: infraestructura transversal necesaria.
- lib/shared/widgets/: componentes visuales compartidos.
- lib/shared/utils/: funciones transversales por responsabilidad.
- lib/features/<modulo>/presentation/pages/: pantallas.
- lib/features/<modulo>/presentation/widgets/: piezas visuales propias.
- lib/features/<modulo>/presentation/controllers/: estado y coordinación.
- lib/features/<modulo>/data/repositories/: acceso a datos.
- lib/features/<modulo>/data/services/: API o almacenamiento.
- lib/features/<modulo>/domain/: reglas y contratos cuando hagan falta.
- lib/features/<modulo>/utils/: funciones reutilizadas dentro del módulo.
- assets/: archivos gráficos y fuentes con licencias.
- test/: pruebas relevantes por módulo.

Crear carpetas/capas cuando haya contenido real. Para la base, usar herramientas del SDK y estado local; seleccionar una solución de estado más amplia solo si los flujos la necesitan. No mezclar varios patrones sin motivo.
