import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexid/app/app.dart';
import 'package:nexid/app/app_dependencies.dart';
import 'package:nexid/core/performance/bounded_lru_cache.dart';
import 'package:nexid/core/performance/device_performance_tier.dart';
import 'package:nexid/core/performance/priority_task_scheduler.dart';
import 'package:nexid/features/reading/domain/credential_models.dart';
import 'package:nexid/features/records/domain/record_models.dart';
import 'package:nexid/features/settings/domain/settings_models.dart';
import 'package:nexid/features/students/domain/student_models.dart';

void main() {
  test(
    'Perfiles de dispositivos limitados (2GB, 3GB, 4GB, Adverso), LRU y Prioridad Critica NFC',
    () async {
      // 1. Verifica presupuestos de los 4 perfiles obligatorios
      for (final DevicePerformanceProfile profile
          in DevicePerformanceProfile.values) {
        DeviceMemoryGuard.instance.applyProfile(profile);
        expect(DeviceMemoryGuard.instance.activeProfile, profile);
        expect(profile.budget.simulatedTotalRamMb, greaterThanOrEqualTo(2048));
        expect(profile.budget.maxImageCacheCount, lessThanOrEqualTo(50));
      }

      // 2. Verifica cache LRU acotada y deduplicacion en vuelo
      final BoundedLruCache<String, int> lru =
          BoundedLruCache<String, int>(maxEntries: 3);
      int loaderCalls = 0;
      final List<int> concurrent = await Future.wait<int>(<Future<int>>[
        lru.putIfAbsentAsync('K1', () async {
          loaderCalls++;
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return 100;
        }),
        lru.putIfAbsentAsync('K1', () async {
          loaderCalls++;
          return 200;
        }),
      ]);
      expect(concurrent, <int>[100, 100]);
      expect(loaderCalls, 1);

      lru.put('K2', 2);
      lru.put('K3', 3);
      lru.put('K4', 4);
      expect(lru.length, 3);
      expect(lru.get('K1'), isNull); // Expulsado por limite LRU (maxEntries = 3)

      // 3. Verifica que tarea critica NFC se ejecuta sin ser bloqueada por baja prioridad
      PriorityTaskScheduler.instance.configureMaxConcurrency(1);
      final List<String> order = <String>[];
      final Future<void> lowTask = PriorityTaskScheduler.instance.schedule<void>(
        priority: TaskPriority.low,
        action: () async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          order.add('low');
        },
      );
      final Future<void> criticalNfc =
          PriorityTaskScheduler.instance.runCritical<void>(() async {
        order.add('critical_nfc');
      });
      await Future.wait<void>(<Future<void>>[criticalNfc, lowTask]);
      expect(order.first, 'critical_nfc');
    },
  );

  testWidgets(
    'Suite integral de 12 escenarios de rendimiento en Gama Baja Extrema (2 GB RAM)',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Escenario 1: Inicio en frio y autenticacion
      final Stopwatch coldStartWatch = Stopwatch()..start();
      await tester.pumpWidget(const NexIdApp());
      await tester.pumpAndSettle();
      coldStartWatch.stop();
      expect(coldStartWatch.elapsedMilliseconds, lessThan(2500));

      await tester.enterText(find.byType(TextField).first, 'operador.puerta1');
      await tester.enterText(find.byType(TextField).last, 'demopassword');
      await tester.tap(find.text('Iniciar Sesion'));
      await tester.pumpAndSettle();

      final BuildContext shellContext = tester.element(find.text('Lectura'));
      final AppDependencies deps = AppDependencies.of(shellContext);

      // Activa perfil Gama Baja Extrema (2 GB RAM)
      deps.settingsController.setDeviceProfile(
        DevicePerformanceProfile.ultraLowEnd2Gb,
      );
      await tester.pumpAndSettle();
      expect(deps.settingsController.effectiveReduceMotion, isTrue);

      // Escenario 2: Navegacion rapida entre los 5 modulos sin bloqueo
      for (final String tab in <String>[
        'Registros',
        'Alumnos',
        'Reportes',
        'Ajustes',
        'Lectura',
      ]) {
        await tester.tap(find.text(tab));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      // Escenario 3 y 4: Apertura de lista extensa de alumnos (150 alumnos)
      // con paginacion (lote=6 en 2GB) e hidratacion LRU acotada (max=3 fichas)
      deps.studentsController.repository.seedBulkSummariesForTesting(150);
      await deps.studentsController.loadStudents();
      await tester.tap(find.text('Alumnos'));
      await tester.pumpAndSettle();
      expect(deps.studentsController.totalCount, 150);
      expect(deps.studentsController.paginatedStudents.length, 6);

      // Hidrata 5 fichas seguidas y comprueba que la cache en RAM no supera 3 (2GB budget)
      final List<Student> firstFive =
          deps.studentsController.students.take(5).toList();
      for (final Student s in firstFive) {
        await deps.studentsController.hydrateStudentForProfile(s);
      }
      expect(
        deps.studentsController.repository.cachedExtendedDetailCount,
        lessThanOrEqualTo(3),
      );

      // Escenario 5 y 9: Lectura NFC critica concurrente con generacion de reporte PDF
      final Future<void> reportFuture = deps.reportsController.requestReport(
        title: 'Reporte Masivo A4',
        format: 'PDF',
        placeName: 'Puerta Principal',
      );
      final Stopwatch nfcWatch = Stopwatch()..start();
      await deps.readingController.simulateScan(
        token: 'NFC-TOKEN-1001',
        placeId: 'PL-01',
        forceMedium: ReadingMedium.nfc,
      );
      nfcWatch.stop();
      expect(deps.readingController.lastResult, isNotNull);
      expect(nfcWatch.elapsedMilliseconds, lessThan(800));
      await reportFuture;
      await tester.pumpAndSettle();

      // Escenario 6 y 7: Uso con conexion adversa / sin conexion y posterior sincronizacion
      deps.settingsController.setDeviceProfile(
        DevicePerformanceProfile.adverseConditions,
      );
      deps.settingsController.toggleSimulateOffline(true);
      final int beforePending = deps.recordsController.pendingCount;
      await deps.recordsController.createRecord(
        studentId: 'STU-1001',
        studentCode: '2023-0149',
        studentName: 'Ana Maria Morales Quispe',
        placeId: 'PL-01',
        placeName: 'Puerta Principal',
        eventType: EventType.entrada,
        medium: ReadingMedium.nfc,
      );
      expect(deps.recordsController.pendingCount, beforePending + 1);

      deps.settingsController.toggleSimulateOffline(false);
      final Future<void> syncFuture = deps.syncController.syncNow();
      await tester.pump(const Duration(seconds: 3));
      await syncFuture;
      await deps.recordsController.loadRecords();
      expect(deps.recordsController.pendingCount, 0);

      // Escenario 8: Cambio entre modo claro y oscuro sin fugas
      deps.settingsController.setThemePreference(AppThemePreference.dark);
      await tester.pumpAndSettle();
      deps.settingsController.setThemePreference(AppThemePreference.light);
      await tester.pumpAndSettle();

      // Escenario 10 y 11: Paso a segundo plano y presion de memoria (RAM baja)
      final int cleanupsBefore = DeviceMemoryGuard.instance.memoryCleanupCount;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      tester.binding.handleMemoryPressure();
      await tester.pump();
      expect(
        DeviceMemoryGuard.instance.memoryCleanupCount,
        greaterThan(cleanupsBefore),
      );
      expect(
        deps.studentsController.repository.cachedExtendedDetailCount,
        equals(0),
      );
      // Los registros en SQLite/Outbox NO se borran al liberar cache temporal
      expect(deps.recordsController.totalCount, greaterThan(0));

      // Escenario 12: Uso prolongado (busquedas rapidas con debounce sin fugas de Timer)
      for (int i = 0; i < 15; i++) {
        deps.studentsController.setSearchQueryDebounced('Alumno $i');
        deps.recordsController.setSearchQueryDebounced('REC-$i');
      }
      await tester.pump(const Duration(milliseconds: 400));
      deps.studentsController.clearFilters();
      deps.recordsController.clearFilters();
      await tester.pumpAndSettle();
    },
  );
}
