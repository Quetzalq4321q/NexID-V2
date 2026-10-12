import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';
import 'package:nexid/features/records/presentation/widgets/records_filter_dropdown.dart';
import 'package:nexid/features/session/presentation/widgets/google_account_avatar_button.dart';
import 'package:nexid/features/settings/presentation/widgets/theme_appearance_card.dart';

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

  testWidgets('NexID navegacion, accesibilidad Claro/Oscuro, Alumnos, Registros y PDF A4', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
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

    expect(find.text('NexID'), findsOneWidget);
    expect(find.byType(GoogleAccountAvatarButton), findsOneWidget);

    // 1. Navega a Registros y verifica KPIs, filtro y detalle auditable
    await tester.tap(find.text('Registros'));
    await tester.pumpAndSettle();
    expect(find.byType(RecordsFilterDropdown), findsOneWidget);
    expect(find.text('Total Eventos'), findsOneWidget);

    // Abre el detalle auditable de un registro
    await tester.tap(find.text('Ana Maria Morales Quispe').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Detalle Auditable de Registro'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // 2. Navega a Alumnos y abre el Expediente Integral por pestañas
    await tester.tap(find.text('Alumnos'));
    await tester.pumpAndSettle();
    expect(find.text('Padron Local'), findsOneWidget);
    await tester.tap(find.text('Ana Maria Morales Quispe').first);
    await tester.pumpAndSettle();
    expect(find.text('Expediente Integral de Alumno'), findsOneWidget);
    expect(find.text('Academico'), findsOneWidget);
    await tester.tap(find.text('Academico'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Promedio Ponderado'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 3. Navega a Reportes y abre la Vista Previa PDF en formato A4
    await tester.tap(find.text('Reportes'));
    await tester.pumpAndSettle();
    expect(find.text('Vista Previa Institucional A4 (PDF)'), findsOneWidget);
    await tester.tap(find.text('Ver PDF Ficha de Alumno'));
    await tester.pumpAndSettle();
    expect(find.text('Vista Previa de Documento PDF (A4)'), findsOneWidget);
    expect(find.text('Pagina 1 de 1'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // 4. Navega a Ajustes y verifica el sistema de Accesibilidad y Temas (Claro/Oscuro/Auto)
    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    expect(find.byType(ThemeAppearanceCard), findsOneWidget);
    expect(find.text('Apariencia y Tema del Sistema'), findsOneWidget);

    // Cambia a Modo Oscuro y verifica que la UI no presente errores
    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Oscuro activo'), findsOneWidget);

    // Cambia a Modo Claro y verifica independencia visual
    await tester.tap(find.text('Claro'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Claro activo'), findsOneWidget);

    await tester.ensureVisible(find.textContaining('v0.0.8'));
    await tester.pumpAndSettle();
    expect(find.textContaining('v0.0.8'), findsOneWidget);
  });

  testWidgets('NexID adaptabilidad en pantalla estrecha extrema (320px)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const NexIdApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'operador.puerta1');
    await tester.enterText(find.byType(TextField).last, 'demopassword');
    await tester.tap(find.text('Iniciar Sesion'));
    await tester.pumpAndSettle();

    expect(find.text('NexID'), findsOneWidget);
    expect(find.byType(GoogleAccountAvatarButton), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Apariencia y Tema del Sistema'), findsOneWidget);
  });
}
