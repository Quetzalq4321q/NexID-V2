import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';

void main() {
  testWidgets('NexID arranque inicial y pantalla de acceso', (WidgetTester tester) async {
    // Inicia la aplicacion NexID
    await tester.pumpWidget(const NexIdApp());
    await tester.pumpAndSettle();

    // Comprueba que el titulo y el boton de acceso se muestren
    expect(find.text('NexID'), findsOneWidget);
    expect(find.text('Iniciar Sesion'), findsOneWidget);
  });
}
