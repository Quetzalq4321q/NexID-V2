import 'package:flutter/material.dart';
import '../features/places/data/places_repository.dart';
import '../features/places/presentation/controllers/places_controller.dart';
import '../features/reading/data/reading_repository.dart';
import '../features/reading/presentation/controllers/reading_controller.dart';
import '../features/records/data/records_repository.dart';
import '../features/records/presentation/controllers/records_controller.dart';
import '../features/reports/data/reports_repository.dart';
import '../features/reports/presentation/controllers/reports_controller.dart';
import '../features/session/data/session_repository.dart';
import '../features/session/presentation/controllers/session_controller.dart';
import '../features/session/presentation/pages/login_page.dart';
import '../features/students/data/students_repository.dart';
import '../features/students/presentation/controllers/students_controller.dart';
import '../features/sync/data/sync_repository.dart';
import '../features/sync/presentation/controllers/sync_controller.dart';
import '../features/uploads/data/uploads_repository.dart';
import '../features/uploads/presentation/controllers/uploads_controller.dart';
import 'app_dependencies.dart';
import 'app_shell.dart';
import 'app_theme.dart';

/// Composicion raiz de la aplicacion NexID segun agent/02_ARQUITECTURA.md.
class NexIdApp extends StatefulWidget {
  const NexIdApp({super.key});

  @override
  State<NexIdApp> createState() => _NexIdAppState();
}

class _NexIdAppState extends State<NexIdApp> {
  late final SessionRepository _sessionRepository;
  late final PlacesRepository _placesRepository;
  late final ReadingRepository _readingRepository;
  late final StudentsRepository _studentsRepository;
  late final RecordsRepository _recordsRepository;
  late final UploadsRepository _uploadsRepository;
  late final ReportsRepository _reportsRepository;
  late final SyncRepository _syncRepository;

  late final SessionController _sessionController;
  late final PlacesController _placesController;
  late final ReadingController _readingController;
  late final StudentsController _studentsController;
  late final RecordsController _recordsController;
  late final UploadsController _uploadsController;
  late final ReportsController _reportsController;
  late final SyncController _syncController;

  @override
  void initState() {
    super.initState();
    _sessionRepository = SessionRepository();
    _placesRepository = PlacesRepository();
    _readingRepository = ReadingRepository();
    _studentsRepository = StudentsRepository();
    _recordsRepository = RecordsRepository();
    _uploadsRepository = UploadsRepository();
    _reportsRepository = ReportsRepository();
    _syncRepository = SyncRepository(recordsRepository: _recordsRepository);

    _sessionController = SessionController(repository: _sessionRepository);
    _placesController = PlacesController(repository: _placesRepository);
    _readingController = ReadingController(repository: _readingRepository);
    _studentsController = StudentsController(repository: _studentsRepository);
    _recordsController = RecordsController(repository: _recordsRepository);
    _uploadsController = UploadsController(repository: _uploadsRepository);
    _reportsController = ReportsController(repository: _reportsRepository);
    _syncController = SyncController(repository: _syncRepository);
  }

  @override
  void dispose() {
    _sessionController.dispose();
    _placesController.dispose();
    _readingController.dispose();
    _studentsController.dispose();
    _recordsController.dispose();
    _uploadsController.dispose();
    _reportsController.dispose();
    _syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      sessionController: _sessionController,
      placesController: _placesController,
      readingController: _readingController,
      studentsController: _studentsController,
      recordsController: _recordsController,
      uploadsController: _uploadsController,
      reportsController: _reportsController,
      syncController: _syncController,
      child: MaterialApp(
        title: 'NexID',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: ListenableBuilder(
          listenable: _sessionController,
          builder: (BuildContext context, _) {
            if (!_sessionController.isAuthenticated) {
              return LoginPage(controller: _sessionController);
            }
            return const AppShell();
          },
        ),
      ),
    );
  }
}
