# Guia Oficial de Identidad Visual y Branding - NexID

Esta guia establece de manera directa e inmutable la identidad visual y las normas de diseno de **NexID**, conforme a lo estipulado en el contrato y en `agent/03_DISENO.md`.

---

## 1. Tokens de Color

Todos los colores son planos y solidos. Quedan expresamente prohibidos degradados, iluminaciones decorativas o efectos neon.

| Token | Hexadecimal | Uso y Reglas de Aplicacion |
|---|---|---|
| **Azul Primario** | `#1D4ED8` | Color principal para encabezados destacados, botones primarios, iconos activos y elementos de seleccion. |
| **Morado Claro (Superficie)** | `#DDD6FE` | Superficie de contraste y contenedores destacados. **Regla estricta:** Utilizar siempre con texto oscuro (`#111827`); nunca usar texto blanco ni usar morado como color de texto sobre fondo blanco. |
| **Fondo Principal** | `#FFFFFF` | Fondo blanco limpio para pantallas y superficies generales. |
| **Superficie de Tarjetas** | `#F9FAFB` | Fondo sutil para tarjetas y contenedores de campos. |
| **Texto Principal** | `#111827` | Texto primario de alta legibilidad y contraste. |
| **Texto Secundario** | `#4B5563` | Subtitulos, etiquetas de ayuda y metadatos. |
| **Bordes y Separadores** | `#E5E7EB` | Lineas divisorias y bordes de tarjetas y campos. |

### Estados Semanticos Accesibles
- **Exito / Confirmado:** `#059669` (Verde solido)
- **Advertencia / Pendiente:** `#D97706` (Ambar solido)
- **Error / Revision Requerida:** `#DC2626` (Rojo solido accesible)

---

## 2. Tipografia

- **Familia unica:** `Roboto` en todas las plataformas y componentes.
- No se admite la incorporacion de otras fuentes tipograficas.
- **Jerarquia:**
  - Titulos principales: 24 px (`w700`)
  - Subtitulos y secciones: 18 px (`w600`)
  - Cuerpo de texto: 16 px (`w400`)
  - Texto secundario: 14 px (`w400`)
  - Botones y acciones: 16 px (`w600`)
  - Etiquetas tecnicas / chips: 12 px (`w500`)

---

## 3. Normas de Interfaz y Prohibicion de Emojis

1. **Cero Emojis:** Queda terminantemente prohibido el uso de emojis en codigo fuente, comentarios, nombres de variables, logs o en la interfaz grafica de usuario. Los iconos son representaciones vectoriales limpias (Material Icons o archivos SVG autorizados).
2. **Dimensiones Accesibles:**
   - Altura minima de controles tactiles: **48 px**.
   - Radio de esquinas estandar: **12 px**.
   - Espaciados del sistema: **8 px**, **16 px**, **24 px** y **32 px**.
3. **Claridad de Acciones:**
   - Botones simples con verbos activos directos (e.g., "Iniciar Sesion", "Activar Captura", "Registrar Ingreso", "Sincronizar").
   - Sin pantallas informativas de relleno ni tutoriales innecesarios. Toda pantalla resuelve una tarea operativa concreta.
