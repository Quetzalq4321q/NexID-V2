import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_typography.dart';
import '../core/responsive/responsive_layout.dart';
import '../features/reading/presentation/pages/reading_page.dart';
import '../features/records/presentation/pages/records_page.dart';
import '../features/reports/presentation/pages/reports_page.dart';
import '../features/session/domain/session_models.dart';
import '../features/session/presentation/widgets/google_account_avatar_button.dart';
import '../features/session/presentation/widgets/google_account_sheet.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/students/presentation/pages/students_page.dart';
import '../features/sync/presentation/widgets/sync_status_banner.dart';
import 'app_dependencies.dart';

/// Contenedor principal de la aplicacion con navegacion adaptable.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AppDependencies deps = AppDependencies.of(context);
    final OperatorUser? user = deps.sessionController.currentUser;
    final bool isCompact = ResponsiveLayout.isCompact(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: const Icon(
                Icons.nfc,
                size: 20,
                color: AppColors.background,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSmall),
            const Flexible(
              child: Text(
                'NexID',
                style: AppTypography.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (user != null)
            GoogleAccountAvatarButton(
              user: user,
              onTap: () {
                final String activePlace =
                    deps.placesController.selectedPlace?.name ??
                        'Punto no asignado';
                GoogleAccountSheet.show(
                  context,
                  user: user,
                  activePlaceName: activePlace,
                  onLogout: () => deps.sessionController.logout(),
                  onOpenSettings: () {
                    setState(() => _currentIndex = 4);
                  },
                );
              },
            ),
          const SizedBox(width: AppDimensions.spaceSmall),
        ],
      ),
      body: Column(
        children: [
          // Banner de sincronizacion constante en la parte superior
          ListenableBuilder(
            listenable: deps.syncController,
            builder: (BuildContext context, _) {
              return SyncStatusBanner(controller: deps.syncController);
            },
          ),
          Expanded(
            child: Row(
              children: [
                if (!isCompact)
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (int index) {
                      setState(() => _currentIndex = index);
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.qr_code_scanner_outlined),
                        selectedIcon: Icon(Icons.qr_code_scanner),
                        label: Text('Lectura'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.list_alt_outlined),
                        selectedIcon: Icon(Icons.list_alt),
                        label: Text('Registros'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.people_alt_outlined),
                        selectedIcon: Icon(Icons.people_alt),
                        label: Text('Alumnos'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.assessment_outlined),
                        selectedIcon: Icon(Icons.assessment),
                        label: Text('Reportes'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Ajustes'),
                      ),
                    ],
                  ),
                Expanded(
                  child: _buildCurrentView(deps),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isCompact
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() => _currentIndex = index);
              },
              indicatorColor: AppColors.surfaceAccent,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.qr_code_scanner_outlined),
                  selectedIcon: Icon(Icons.qr_code_scanner),
                  label: 'Lectura',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: 'Registros',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_alt_outlined),
                  selectedIcon: Icon(Icons.people_alt),
                  label: 'Alumnos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assessment_outlined),
                  selectedIcon: Icon(Icons.assessment),
                  label: 'Reportes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Ajustes',
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildCurrentView(AppDependencies deps) {
    return switch (_currentIndex) {
      0 => ReadingPage(
          readingController: deps.readingController,
          placesController: deps.placesController,
        ),
      1 => RecordsPage(controller: deps.recordsController),
      2 => StudentsPage(controller: deps.studentsController),
      3 => ReportsPage(
          reportsController: deps.reportsController,
          placesController: deps.placesController,
        ),
      4 => SettingsPage(
          settingsController: deps.settingsController,
          sessionController: deps.sessionController,
          placesController: deps.placesController,
          syncController: deps.syncController,
        ),
      _ => ReadingPage(
          readingController: deps.readingController,
          placesController: deps.placesController,
        ),
    };
  }
}
