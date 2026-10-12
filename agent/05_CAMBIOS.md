# Cambios, autorización y backups

- Cambios del núcleo funcional requieren aprobación explícita ANTES de implementarlos: autenticación, autorización, permisos Android, persistencia o migraciones, borrado de datos, pagos, contratos de API y comportamiento central existente.
- Presentar propuesta concreta: motivo, archivos afectados, comportamiento antes/después, riesgo, prueba y reversión. Se puede investigar y preparar una propuesta sin modificar el núcleo.
- No pedir aprobación por ajustes reversibles de UI ya autorizados. La aprobación solo cubre el alcance descrito.
- Ante un cambio dudoso o de consecuencias desconocidas: detener la mutación y crear primero un backup FUERA de la carpeta principal. Un backup no sustituye la aprobación del núcleo.
- Verificar el backup, registrar ruta y SHA-256; excluir secretos, claves y datos personales. Si una recuperación necesita esos datos, acordar almacenamiento seguro antes de continuar.
- No resetear Git, borrar archivos existentes ni sobrescribir cambios del usuario para resolver conflictos.
- Cada cambio debe documentarse en CHANGELOG.md dentro de Unreleased. Indicar fecha, motivo, módulo, estado (propuesto/implementado/verificado/activado/revertido), pruebas y aprobación cuando aplique.
- Nunca marcar activado lo que solo fue escrito. Activado significa integrado en el entorno acordado y validado. Marcar verificaciones pendientes con honestidad.

## Backup externo
Destino ejemplo: carpeta hermana ../backups/<proyecto>/<fecha-hora>/, nunca dentro del proyecto. Comprobar rutas resueltas y evitar enlaces que regresen al proyecto. Crear snapshot de archivos afectados y dependencias necesarias para restaurarlos. Excluir secretos y datos personales; documentar exclusiones. Verificar integridad mediante SHA-256 y comprobar que existe una ruta de restauración. Si el respaldo falla, no hacer la modificación incierta.

## Propuesta de cambio protegido
Motivo / archivos / antes y después / riesgo / prueba / backup si aplica / reversión / decisión pendiente del usuario. Registrar aprobación textual y alcance sin datos privados innecesarios.

## Activación
Implementado: código escrito. Verificado: controles relevantes pasaron. Activado: integración y ejecución confirmadas en el entorno acordado. Si usa flags, documentar valor y entorno; no introducir flags por defecto para toda modificación.
