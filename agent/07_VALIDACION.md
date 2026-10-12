# Validación y entrega

- Revisar diff, dependencias y alcance; conservar cambios ajenos.
- `dart format lib test` y `flutter analyze`.
- `flutter test` con pruebas pertinentes para el comportamiento cambiado.
- `flutter build apk --debug` para entrega Android; integración nativa y permisos también requieren prueba en dispositivo o emulador.
- Verificar pantallas pequeñas, texto ampliado, accesibilidad, carga, vacío, error y recuperación cuando apliquen.
- Validar que assets existen, que no hay emojis y que funciones/componentes repetidos tienen una única implementación.
- No añadir tests que solo reflejen líneas de implementación. Cubrir flujos, reglas y regresiones reales.
- Si falta el SDK o una dependencia, registrar bloqueo; nunca informar que compiló.
- Actualizar CHANGELOG.md y ESTADO.md. Informar qué cambió, qué se probó y qué queda pendiente.

Documentación técnica: https://docs.flutter.dev/app-architecture/guide y https://docs.flutter.dev/app-architecture/recommendations. Consultadas 2026-10-11. Confirmar documentación oficial para APIs o dependencias específicas al implementarlas.
