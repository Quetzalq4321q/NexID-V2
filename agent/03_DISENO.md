# Diseño visual

- Colores planos: azul #1D4ED8, morado claro #DDD6FE, fondo #FFFFFF, texto #111827. Sin neón, degradados ni brillos decorativos.
- Una sola familia tipográfica: Roboto en Android. No agregar otra fuente; los pesos y tamaños sí pueden variar. Empaquetar Roboto y su licencia si posteriormente se requiere asegurar la fuente en otras plataformas.
- Botones claros con verbos, jerarquía sencilla, una acción primaria por contexto y espacio en blanco. Referencia de claridad: aplicaciones de Google; no copiar logos ni marcas.
- Toda pantalla debe resolver una tarea. Evitar páginas de información adicional, tutoriales y pantallas de relleno. Ayuda contextual solo cuando sea necesaria para usar una función.
- No ocultar confirmaciones necesarias, mensajes de error, condiciones legales aplicables ni el contexto de permisos.
- Logos e iconos deben ser archivos SVG/PNG/WebP con licencia registrada. No usar emojis en código, comentarios, nombres, textos, logs ni interfaz. No sustituir assets por caracteres Unicode o iconos tipográficos.
- No inventar un logo de marca. El archivo geométrico incluido es un marcador de muestra que debe reemplazarse cuando exista una marca aprobada.
- Usar SafeArea, contenido desplazable, controles de al menos 48 px, texto legible y etiquetas accesibles. Probar texto ampliado y pantallas pequeñas. El morado claro se usa como superficie con texto oscuro, no como texto sobre blanco.

## Tokens
| Elemento | Valor |
|---|---|
| Azul primario | #1D4ED8 |
| Morado claro, superficie | #DDD6FE |
| Fondo | #FFFFFF |
| Texto | #111827 |
| Texto secundario | #4B5563 |
| Borde | #E5E7EB |
| Familia | Roboto |
| Títulos / cuerpo / botón | 24 / 16 / 16 px |
| Espacios | 8 / 16 / 24 / 32 px |
| Radio | 12 px |
| Tamaño mínimo de toque | 48 px |

Paleta inicial solicitada; nombre y logo de la marca aún pendientes. Estados de error pueden usar rojo semántico sólido con texto accesible. Validar contraste y texto ampliado antes de entrega.

## NFC/QR
Pantallas y módulos específicos en 17_MODULOS_FLUJOS.md. La ficha comparte componentes y muestra solo la proyección autorizada recibida; el medio no obliga a duplicar pantallas. No inventar logo Nexlabs ni reutilizar branding externo sin asset aprobado.
