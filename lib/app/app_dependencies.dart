import 'package:flutter/material.dart';
import '../features/places/presentation/controllers/places_controller.dart';
import '../features/reading/presentation/controllers/reading_controller.dart';
import '../features/records/presentation/controllers/records_controller.dart';
import '../features/reports/presentation/controllers/reports_controller.dart';
import '../features/session/presentation/controllers/session_controller.dart';
import '../features/students/presentation/controllers/students_controller.dart';
import '../features/sync/presentation/controllers/sync_controller.dart';
import '../features/uploads/presentation/controllers/uploads_controller.dart';

/// Contenedor de dependencias e inyeccion por contexto segun agent/02_ARQUITECTURA.md.
class AppDependencies extends InheritedWidget {
  const AppDependencies({
    super.key,
    required this.sessionController,
    required this.placesController,
    required this.readingController,
    required this.studentsController,
    required this.recordsController,
    required this.uploadsController,
    required this.reportsController,
    required this.syncController,
    required super.child,
  });

  final SessionController sessionController;
  final PlacesController placesController;
  final ReadingController readingController;
  final StudentsController studentsController;
  final RecordsController recordsController;
  final UploadsController uploadsController;
  final ReportsController reportsController;
  final SyncController syncController;

  static AppDependencies of(BuildContext context) {
    final AppDependencies? result =
        context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(result != null, 'No se encontro AppDependencies en el contexto.');
    return result!;
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) => false;
}
