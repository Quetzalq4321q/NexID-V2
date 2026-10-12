# Uso multiadaptativo

Interpretación inicial: una misma app se adapta a tamaños de ventana, orientación, métodos de entrada y necesidades de accesibilidad. No implica soporte web/iOS/escritorio ya autorizado ni roles de usuario inventados.

- Diseñar por ancho disponible mediante LayoutBuilder/MediaQuery, no por nombre del dispositivo.
- Puntos de partida: compacto <600, medio 600–839, amplio >=840 píxeles lógicos. Ajustar según contenido y verificar límites.
- Compartir lógica, estado y componentes. Crear composiciones visuales distintas solo cuando el espacio lo justifique; no duplicar funcionalidades ni pantallas enteras por dispositivo.
- Compacto: una columna. Medio/amplio: paneles o columnas cuando mejoren la tarea. No agregar menús solo para llenar espacio.
- Preservar estado al rotar/redimensionar. Respetar SafeArea, teclado, foco y navegación accesible.
- Evitar alturas rígidas de texto y desbordamientos. Probar 320/360/600/840/1200 de ancho cuando el destino lo admita y texto aumentado al 200%.
- La densidad de información cambia según espacio; los permisos, validaciones y reglas del negocio permanecen consistentes.
- Probar también conexión lenta, desconexión y reconexión. Adaptación visual y adaptación de red son responsabilidades separadas.
