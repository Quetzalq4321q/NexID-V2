# Versionado y trazabilidad

## Versión normal
Versión del proyecto: MAJOR.MINOR.PATCH, inicialmente 0.0.0. Flutter: version: 0.0.0+1; el número después de + es el build técnico y crece con las compilaciones distribuidas. No colocar letras en la versión.

- PATCH: corrección compatible, por ejemplo 0.0.0 -> 0.0.1.
- MINOR: funcionalidad compatible, por ejemplo 0.0.1 -> 0.1.0.
- MAJOR: cambio incompatible; primer lanzamiento estable puede ser 1.0.0 cuando cumpla criterios acordados.
- Durante 0.x documentar explícitamente cualquier ruptura y migración: no asumir estabilidad de contratos.
- Un cambio de color no obliga por sí solo a aumentar MINOR. Clasificar por impacto real.
- Cambios en curso se registran bajo Unreleased; la versión se asigna al integrar una entrega coherente. No subir una versión por cada archivo.

## Identificadores del historial
Letras para cambios visuales: VIS-A, VIS-B, …, VIS-Z, VIS-AA. Números para funcionalidad: FUN-1, FUN-2, … . Son identificadores, no versiones. Un cambio mixto puede vincular ambos. No reutilizar IDs, incluso si se revierte. Documentación y refactors sin impacto observable se clasifican como DOC/REF con un ID trazable; describir efecto en lógica cuando lo haya.

## Registro obligatorio por cambio
Usar 11_PLANTILLA_CAMBIO.md. El historial debe permitir saber:
1. Qué fallaba o qué se pidió y cómo reproducirlo.
2. Qué hipótesis se evaluó y por qué se eligió la solución, sin guardar conversaciones completas.
3. Cómo funcionaba la lógica antes y cómo funciona después.
4. Qué archivos, símbolos, datos, contratos o configuración cambiaron.
5. Qué commit/diff identifica exactamente el cambio y cuál es el estado previo.
6. Qué se probó, con resultados reales, y qué falta comprobar.
7. Cómo revertir código y lógica; qué datos requieren migración y qué no se puede revertir automáticamente.

Git guarda código y diffs; Markdown guarda motivos y decisiones. No duplicar todo el código en el changelog. Sin Git, guardar patch o snapshot previo verificable fuera del proyecto antes de cambiar; referenciar ruta y hash reales.

## Recuperación
Preferir revertir el commit específico con una nueva reversión, conservando el historial y cambios ajenos. No hacer reset --hard, borrados globales ni sobrescribir trabajo posterior. Si hay dependencias entre cambios, identificarlas primero. Revertir código no revierte automáticamente bases de datos, archivos del servidor o efectos externos. Cambios del núcleo, datos o permisos requieren autorización previa también al revertir, salvo autorización explícita vigente que cubra esa reversión.

Cada reversión es una nueva entrada con motivo, referencia al cambio original, alcance, pruebas y versión correspondiente. Probar el comportamiento recuperado antes de marcarlo activado.
