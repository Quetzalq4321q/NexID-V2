import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';
import 'package:nexid/features/records/presentation/widgets/records_filter_dropdown.dart';
import 'package:nexid/features/session/presentation/widgets/google_account_avatar_button.dart';

void main() {
  testWidgets('NexID arranque inicial y pantalla de acceso', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexIdApp());
    await tester.pumpAndSettle();

    expect(find.text('NexID'), findsOneWidget);
    expect(find.text('Iniciar Sesion'), findsOneWidget);
  });

  testWidgets('NexID navegacion, cuenta estilo Google y adaptabilidad compacta (360px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexIdApp());
    await tester.pumpAndSettle();

    // Ingresa credenciales de prueba
    await tester.enterText(find.byType(TextField).first, 'operador.puerta1');
    await tester.enterText(find.byType(TextField).last, 'demopassword');
    await tester.tap(find.text('Iniciar Sesion'));
    await tester.pumpAndSettle();

    // Verifica que AppShell, barra superior, estado NFC y boton circular estilo Google se rendericen
    expect(find.text('NexID'), findsOneWidget);
    expect(find.text('Punto de control operativo'), findsOneWidget);
    expect(find.text('NFC Completo'), findsOneWidget);
    expect(find.text('QR Parcial'), findsOneWidget);
    expect(find.text('NFC Activo'), findsOneWidget);
    expect(find.byType(GoogleAccountAvatarButton), findsOneWidget);

    // Prueba la apertura y visualizacion de la cuenta estilo Google desde el AppBar
    await tester.tap(find.byType(GoogleAccountAvatarButton));
    await tester.pumpAndSettle();
    expect(find.text('Carlos Vega'), findsWidgets);
    expect(find.text('Permisos asignados:'), findsOneWidget);

    // Cierra el modal de cuenta de Google
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Prueba resolucion de credencial y visualizacion de Ficha de Alumno sin overflow
    await tester.scrollUntilVisible(find.text('CARD-NFC-8821'), 200);
    await tester.tap(find.text('CARD-NFC-8821'));
    await tester.pumpAndSettle();
    expect(find.text('Ana Maria Morales Quispe'), findsOneWidget);
    expect(find.text('Registrar Ingreso'), findsOneWidget);

    // Cierra ficha de alumno y vuelve a lectura
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Navega a Registros y verifica el desplegable de opciones y filtros
    await tester.tap(find.text('Registros'));
    await tester.pumpAndSettle();
    expect(find.byType(RecordsFilterDropdown), findsOneWidget);
    expect(find.text('Todos los registros'), findsOneWidget);

    // Abre el desplegable de opciones y filtros
    await tester.tap(find.text('Todos los registros'));
    await tester.pumpAndSettle();
    expect(find.text('Solo pendientes'), findsWidgets);
    await tester.tap(find.text('Solo pendientes').last);
    await tester.pumpAndSettle();

    // Navega a Alumnos
    await tester.tap(find.text('Alumnos'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    // Navega a Reportes
    await tester.tap(find.text('Reportes'));
    await tester.pumpAndSettle();
    expect(find.text('Generar Reporte'), findsOneWidget);

    // Navega a Ajustes (Configuracion)
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    expect(find.text('Preferencias de Lectura'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sincronizacion y Red'), 100);
    expect(find.text('Sincronizacion y Red'), findsOneWidget);
    expect(find.text('Vibracion al detectar credencial'), findsWidgets);
    await tester.scrollUntilVisible(find.textContaining('v0.0.5'), 100);
    expect(find.textContaining('v0.0.5'), findsOneWidget);
  });

  testWidgets('NexID adaptabilidad en pantalla estrecha extrema (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexIdApp());
    await tester.pumpAndSettle();

    // Ingresa credenciales de prueba en 320px
    await tester.enterText(find.byType(TextField).first, 'operador.puerta1');
    await tester.enterText(find.byType(TextField).last, 'demopassword');
    await tester.tap(find.text('Iniciar Sesion'));
    await tester.pumpAndSettle();

    // Verifica que en 320px la pantalla cargue sin errores de desbordamiento
    expect(find.text('NexID'), findsOneWidget);
    expect(find.text('NFC Completo'), findsOneWidget);
    expect(find.byType(GoogleAccountAvatarButton), findsOneWidget);

    // Navega a Ajustes en 320px
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Preferencias de Lectura'), findsOneWidget);
  });
}
