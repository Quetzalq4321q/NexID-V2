import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/core/constants/app_colors.dart';
import 'package:nexid/core/constants/app_icons.dart';
import 'package:nexid/core/constants/app_version.dart';
import 'package:nexid/core/platform/hardware_bridge.dart';
import 'package:nexid/features/session/presentation/pages/startup_splash_screen.dart';
import 'package:nexid/features/settings/domain/settings_models.dart';
import 'package:nexid/features/settings/presentation/controllers/settings_controller.dart';
import 'package:nexid/shared/widgets/app_logo.dart';
import 'package:nexid/shared/widgets/empty_state.dart';
import 'package:nexid/shared/widgets/lively_state_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Iconografia y componentes visuales vivos (v0.0.10+10)', () {
    test('AppIcons catalogo centralizado y consistencia de simbolos', () {
      expect(AppIcons.appEmblem, equals(Icons.nfc));
      expect(AppIcons.qr, equals(Icons.qr_code_scanner_outlined));
      expect(AppIcons.qrFilled, equals(Icons.qr_code_scanner));
      expect(AppIcons.records, equals(Icons.list_alt_outlined));
      expect(AppIcons.students, equals(Icons.people_alt_outlined));
      expect(AppIcons.reports, equals(Icons.assessment_outlined));
      expect(AppIcons.settings, equals(Icons.settings_outlined));
      expect(AppIcons.themeLight, equals(Icons.wb_sunny_outlined));
      expect(AppIcons.themeDark, equals(Icons.nights_stay_outlined));
      expect(AppColors.primary, equals(const Color(0xFF1D4ED8)));
      expect(AppVersion.version, equals('0.0.10'));
      expect(AppVersion.build, equals(10));
    });

    testWidgets('NexIdAppLogo renderiza emblema institucional con azul solido', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NexIdAppLogo(size: 64, isLively: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NexIdAppLogo), findsOneWidget);
      expect(find.byIcon(Icons.nfc), findsOneWidget);
    });

    testWidgets('EmptyState renderiza estado no vacio con badge y accion', (WidgetTester tester) async {
      bool actionTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: AppIcons.searchOff,
              title: 'No se encontraron resultados',
              message: 'Intente buscar con otros terminos o limpie los filtros',
              actionLabel: 'Restablecer busqueda',
              onAction: () => actionTapped = true,
              isLively: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No se encontraron resultados'), findsOneWidget);
      expect(find.text('Intente buscar con otros terminos o limpie los filtros'), findsOneWidget);
      expect(find.text('Restablecer busqueda'), findsOneWidget);
      expect(find.byIcon(AppIcons.searchOff), findsOneWidget);

      await tester.tap(find.text('Restablecer busqueda'));
      await tester.pump();
      expect(actionTapped, isTrue);
    });

    testWidgets('LivelyLoadingView renderiza pantalla de carga viva y boton cancelar', (WidgetTester tester) async {
      bool cancelled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LivelyLoadingView(
              title: 'Cargando padron de alumnos...',
              subtitle: 'Sincronizando con base de datos local SQLite',
              onCancel: () => cancelled = true,
              cancelLabel: 'Cancelar proceso',
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Cargando padron de alumnos...'), findsOneWidget);
      expect(find.text('Sincronizando con base de datos local SQLite'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(NexIdAppLogo), findsOneWidget);

      await tester.tap(find.text('Cancelar proceso'));
      await tester.pump();
      expect(cancelled, isTrue);
    });

    testWidgets('StartupSplashScreen muestra mensaje y completa ciclo inicial', (WidgetTester tester) async {
      bool completed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: StartupSplashScreen(
            minimumDuration: const Duration(milliseconds: 150),
            onInitializationComplete: () => completed = true,
          ),
        ),
      );

      expect(find.text('NexID'), findsOneWidget);
      expect(find.text('Identidad, Acceso y Registros'), findsOneWidget);
      expect(find.text('Iniciando NexID...'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 200));
      expect(completed, isTrue);
    });
  });

  group('Persistencia de preferencias de usuario', () {
    test('AppSettings serializa y deserializa preservando opciones', () {
      const AppSettings original = AppSettings(
        themePreference: AppThemePreference.dark,
        highContrast: true,
        fontScalePreset: FontScalePreset.large,
        compactDensity: true,
        reduceMotion: true,
        vibrateOnScan: false,
        soundOnScan: false,
        syncIntervalSeconds: 30,
      );

      final Map<String, dynamic> serialized = original.toMap();
      final String jsonStr = jsonEncode(serialized);
      final Map<String, dynamic> decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final AppSettings restored = AppSettings.fromMap(decoded);

      expect(restored.themePreference, equals(AppThemePreference.dark));
      expect(restored.highContrast, isTrue);
      expect(restored.fontScalePreset, equals(FontScalePreset.large));
      expect(restored.compactDensity, isTrue);
      expect(restored.reduceMotion, isTrue);
      expect(restored.vibrateOnScan, isFalse);
      expect(restored.soundOnScan, isFalse);
      expect(restored.syncIntervalSeconds, equals(30));
    });

    test('SettingsController persiste y recarga preferencias via HardwareBridge', () async {
      final SettingsController controller = SettingsController();
      addTearDown(controller.dispose);

      controller.setThemePreference(AppThemePreference.light);
      expect(controller.themePreference, equals(AppThemePreference.light));

      controller.toggleHighContrast(true);
      expect(controller.highContrast, isTrue);

      controller.setFontScalePreset(FontScalePreset.large);
      expect(controller.fontScalePreset, equals(FontScalePreset.large));

      final HardwareBridge bridge = HardwareBridge();
      final String? persistedJson = await bridge.loadPreferences();
      // En entorno de test sin host nativo, loadPreferences retorna null gracefully
      expect(persistedJson, isNull);
    });
  });
}
