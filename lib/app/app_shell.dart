import 'package:flutter/material.dart';
import '../core/constants/app_dimensions.dart';
import '../core/constants/app_icons.dart';
import '../core/constants/app_typography.dart';
import '../core/responsive/responsive_layout.dart';
import '../core/theme/nexid_palette.dart';
import '../shared/widgets/app_logo.dart';
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

/// Contenedor principal de la aplicacion con navegacion adaptable y transiciones suaves.
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
    final NexIdPalette palette = NexIdPalette.of(context);
    final OperatorUser? user = deps.sessionController.currentUser;
    final bool isCompact = ResponsiveLayout.isCompact(context);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NexIdAppLogo(size: 32, borderRadius: 6.0),
            const SizedBox(width: AppDimensions.spaceSmall),
            Flexible(
              child: Text(
                'NexID',
                style: AppTypography.titleMedium.copyWith(
                  color: palette.textPrimary,
                ),
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
                        icon: Icon(AppIcons.qr),
                        selectedIcon: Icon(AppIcons.qrFilled),
                        label: Text('Lectura'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.records),
                        selectedIcon: Icon(AppIcons.recordsFilled),
                        label: Text('Registros'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.students),
                        selectedIcon: Icon(AppIcons.studentsFilled),
                        label: Text('Alumnos'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.reports),
                        selectedIcon: Icon(AppIcons.reportsFilled),
                        label: Text('Reportes'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(AppIcons.settings),
                        selectedIcon: Icon(AppIcons.settingsFilled),
                        label: Text('Ajustes'),
                      ),
                    ],
                  ),
                Expanded(
                  child: reduceMotion
                      ? _buildCurrentView(deps)
                      : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: KeyedSubtree(
                            key: ValueKey<int>(_currentIndex),
                            child: _buildCurrentView(deps),
                          ),
                        ),
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
              indicatorColor: palette.surfaceAccent,
              destinations: const [
                NavigationDestination(
                  icon: Icon(AppIcons.qr),
                  selectedIcon: Icon(AppIcons.qrFilled),
                  label: 'Lectura',
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.records),
                  selectedIcon: Icon(AppIcons.recordsFilled),
                  label: 'Registros',
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.students),
                  selectedIcon: Icon(AppIcons.studentsFilled),
                  label: 'Alumnos',
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.reports),
                  selectedIcon: Icon(AppIcons.reportsFilled),
                  label: 'Reportes',
                ),
                NavigationDestination(
                  icon: Icon(AppIcons.settings),
                  selectedIcon: Icon(AppIcons.settingsFilled),
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
          onBackToPreviousTab: () => setState(() => _currentIndex = 0),
        ),
      _ => ReadingPage(
          readingController: deps.readingController,
          placesController: deps.placesController,
        ),
    };
  }
}
