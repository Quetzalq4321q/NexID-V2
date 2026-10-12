import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';

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

  testWidgets('NexID navegacion y adaptabilidad en pantalla compacta (360px)', (WidgetTester tester) async {
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

    // Verifica que AppShell y barra superior se rendericen sin desbordamiento
    expect(find.text('NexID'), findsOneWidget);
    expect(find.text('Punto de control operativo'), findsOneWidget);
    expect(find.text('NFC Completo'), findsOneWidget);
    expect(find.text('QR Parcial'), findsOneWidget);

    // Prueba resolucion de credencial y visualizacion de Ficha de Alumno sin overflow
    await tester.scrollUntilVisible(find.text('CARD-NFC-8821'), 200);
    await tester.tap(find.text('CARD-NFC-8821'));
    await tester.pumpAndSettle();
    expect(find.text('Ana Maria Morales Quispe'), findsOneWidget);
    expect(find.text('Registrar Ingreso'), findsOneWidget);

    // Cierra ficha de alumno y vuelve a lectura
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Navega a Registros
    await tester.tap(find.text('Registros'));
    await tester.pumpAndSettle();
    expect(find.text('Todos'), findsOneWidget);

    // Navega a Alumnos
    await tester.tap(find.text('Alumnos'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    // Navega a Reportes
    await tester.tap(find.text('Reportes'));
    await tester.pumpAndSettle();
    expect(find.text('Generar Reporte'), findsOneWidget);

    // Navega a Subidas
    await tester.tap(find.text('Subidas'));
    await tester.pumpAndSettle();
    expect(find.text('Seleccionar Foto'), findsOneWidget);
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
  });
}
