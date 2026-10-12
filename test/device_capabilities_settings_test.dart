import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';
import 'package:nexid/app/app_dependencies.dart';
import 'package:nexid/core/performance/device_performance_tier.dart';
import 'package:nexid/core/platform/device_capabilities_models.dart';
import 'package:nexid/features/settings/domain/settings_search_catalog.dart';
import 'package:nexid/features/settings/presentation/controllers/settings_controller.dart';

void main() {
  test(
    'Deteccion de hardware real, respaldo ante datos faltantes y adaptacion automatica',
    () {
      // 1. Respaldo cuando Android no expone metricas (sin inventar cifras)
      final DeviceCapabilitiesSnapshot fallback =
          DeviceCapabilitiesSnapshot.fallbackWhenUnavailable();
      expect(fallback.isRealAndroidTelemetry, isFalse);
      expect(fallback.totalRamMb, isNull);
      expect(fallback.totalRamLabel, 'No reportada por el SO');
      expect(
        DevicePerformanceProfile.resolveAutomaticProfile(fallback),
        DevicePerformanceProfile.lowEnd3Gb,
      );

      // 2. Deteccion de memoria severamente limitada (2 GB / LowRamDevice)
      final DeviceCapabilitiesSnapshot lowEnd2Gb =
          DeviceCapabilitiesSnapshot.fromMap(<String, dynamic>{
        'isRealAndroidTelemetry': true,
        'totalRamMb': 1950,
        'availableRamMb': 380,
        'isLowRamDevice': true,
        'processorCores': 4,
        'cpuArchitecture': 'arm64-v8a',
        'hasActiveNetwork': true,
      });
      expect(lowEnd2Gb.isSeverelyMemoryConstrained, isTrue);
      expect(
        DevicePerformanceProfile.resolveAutomaticProfile(lowEnd2Gb),
        DevicePerformanceProfile.ultraLowEnd2Gb,
      );

      // 3. Dispositivo gama media (4-8 GB) sin restricciones -> Rendimiento completo
      final DeviceCapabilitiesSnapshot midRange =
          DeviceCapabilitiesSnapshot.fromMap(<String, dynamic>{
        'isRealAndroidTelemetry': true,
        'totalRamMb': 6144,
        'availableRamMb': 2800,
        'processMaxHeapMb': 384,
        'isLowRamDevice': false,
        'processorCores': 8,
        'hasActiveNetwork': true,
        'isPowerSaveMode': false,
        'thermalStatus': 'none',
      });
      expect(
        DevicePerformanceProfile.resolveAutomaticProfile(midRange),
        DevicePerformanceProfile.budgetMid4Gb,
      );

      // 4. Sobreescritura manual no falsifica los datos reales del hardware
      final SettingsController ctrl = SettingsController(
        initialCapabilities: midRange,
      );
      expect(ctrl.isAutoPerformance, isTrue);
      expect(ctrl.activeAdaptiveLevel, AdaptivePerformanceLevel.full);
      ctrl.setDeviceProfile(DevicePerformanceProfile.ultraLowEnd2Gb);
      expect(ctrl.isAutoPerformance, isFalse);
      expect(ctrl.capabilities.totalRamMb, 6144);
      ctrl.restoreAutomaticPerformance();
      expect(ctrl.isAutoPerformance, isTrue);
      expect(ctrl.deviceProfile, DevicePerformanceProfile.budgetMid4Gb);
      ctrl.dispose();
    },
  );

  test(
    'Buscador local de configuraciones y filtrado de opciones avanzadas por permisos',
    () {
      // Usuario normal (canAccessAdvanced: false) no ve opciones restringidas
      final List<SettingSearchEntry> operatorAll =
          SettingsSearchCatalog.search('', canAccessAdvanced: false);
      expect(
        operatorAll.any((SettingSearchEntry e) => e.section.isRestricted),
        isFalse,
      );

      final List<SettingSearchEntry> operatorAdvSearch =
          SettingsSearchCatalog.search('simulacion 2gb', canAccessAdvanced: false);
      expect(operatorAdvSearch, isEmpty);

      // Administrador (canAccessAdvanced: true) encuentra opciones avanzadas
      final List<SettingSearchEntry> adminAdvSearch =
          SettingsSearchCatalog.search('simulacion 2gb', canAccessAdvanced: true);
      expect(adminAdvSearch, isNotEmpty);
      expect(adminAdvSearch.first.section, SettingsSectionId.advanced);

      // Busqueda por palabra clave asocia correctamente su seccion
      final List<SettingSearchEntry> cacheSearch =
          SettingsSearchCatalog.search('sqlite cache', canAccessAdvanced: false);
      expect(cacheSearch, isNotEmpty);
      expect(cacheSearch.first.section, SettingsSectionId.storageCache);
    },
  );

  testWidgets(
    'Buscador superior en Ajustes y acceso restringido vs autorizado a Configuracion avanzada',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const NexIdApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'operador.puerta1');
      await tester.enterText(find.byType(TextField).last, 'demopassword');
      await tester.tap(find.text('Iniciar Sesion'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ajustes'));
      await tester.pumpAndSettle();

      // Verifica buscador en la parte superior y busqueda sin coincidencias
      final Finder searchInput = find.byKey(const Key('settings_search_input'));
      expect(searchInput, findsOneWidget);
      await tester.enterText(searchInput, 'inexistente_xyz');
      await tester.pumpAndSettle();
      expect(find.textContaining('Sin coincidencias en Ajustes'), findsOneWidget);

      await tester.tap(find.byKey(const Key('settings_search_clear')));
      await tester.pumpAndSettle();

      // Verifica que Operador estandar tiene Configuracion avanzada restringida
      await tester.ensureVisible(
        find.text('Configuracion avanzada restringida'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Configuracion avanzada restringida'), findsOneWidget);
      expect(
        find.byKey(const Key('advanced_device_profile_dropdown')),
        findsNothing,
      );

      // Autoriza sesion de diagnostico con cuenta de Administrador real
      final BuildContext ctx =
          tester.element(find.text('Configuracion avanzada restringida'));
      final AppDependencies deps = AppDependencies.of(ctx);
      expect(deps.sessionController.authorizeDiagnosticSession('operador.puerta1'), isFalse);
      expect(deps.sessionController.authorizeDiagnosticSession('admin.general'), isTrue);
      await tester.pumpAndSettle();

      expect(
        find.text('Panel Avanzado de Diagnostico y Simulacion'),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('advanced_device_profile_dropdown')),
        findsOneWidget,
      );
    },
  );
}
