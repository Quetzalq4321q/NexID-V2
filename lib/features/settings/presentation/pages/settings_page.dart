import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/theme/nexid_palette.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../places/presentation/controllers/places_controller.dart';
import '../../../session/domain/session_models.dart';
import '../../../session/presentation/controllers/session_controller.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../../domain/settings_search_catalog.dart';
import '../controllers/settings_controller.dart';
import '../widgets/accessibility_controls_card.dart';
import '../widgets/advanced_settings_card.dart';
import '../widgets/low_end_performance_card.dart';
import '../widgets/settings_system_sections.dart';
import '../widgets/theme_appearance_card.dart';

/// Pantalla 5: Configuracion reorganizada en 9 secciones operativas + 1 seccion
/// de Configuracion avanzada restringida, con buscador local instantaneo.
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.settingsController,
    required this.sessionController,
    required this.placesController,
    required this.syncController,
  });

  final SettingsController settingsController;
  final SessionController sessionController;
  final PlacesController placesController;
  final SyncController syncController;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController(text: widget.settingsController.searchQuery);
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.settingsController,
        widget.sessionController,
        widget.placesController,
        widget.syncController,
      ]),
      builder: (BuildContext context, _) {
        final NexIdPalette palette = NexIdPalette.of(context);
        final bool canAdv = widget.sessionController.canAccessAdvancedSettings;
        final List<SettingSearchEntry> matches =
            widget.settingsController.searchSettings(canAccessAdvanced: canAdv);
        final Set<SettingsSectionId> visible =
            matches.map((SettingSearchEntry e) => e.section).toSet();
        final bool hasQuery = widget.settingsController.searchQuery.trim().isNotEmpty;

        return Scaffold(
          backgroundColor: palette.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                widget.settingsController.compactDensity
                    ? AppDimensions.spaceMedium
                    : AppDimensions.spaceLarge,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchBar(hasQuery),
                    const SizedBox(height: AppDimensions.spaceMedium),
                    if (hasQuery && matches.isNotEmpty) _buildSearchSummary(matches, palette),
                    if (matches.isEmpty)
                      EmptyState(
                        icon: Icons.search_off_outlined,
                        message:
                            'Sin coincidencias en Ajustes para "${widget.settingsController.searchQuery}".',
                        actionLabel: 'Limpiar busqueda',
                        onAction: _clearSearch,
                      )
                    else
                      ..._buildMatchingSections(visible, palette),
                    const SizedBox(height: AppDimensions.spaceLarge),
                    _buildActionButtons(palette),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(bool hasQuery) {
    return TextField(
      key: const Key('settings_search_input'),
      controller: _searchTextController,
      onChanged: widget.settingsController.setSearchQuery,
      decoration: InputDecoration(
        labelText: 'Buscar en configuracion',
        hintText: 'Ej. tema, contraste, cache, nfc, sincronizar...',
        prefixIcon: const Icon(Icons.search_outlined, size: 20),
        suffixIcon: hasQuery
            ? IconButton(
                key: const Key('settings_search_clear'),
                icon: const Icon(Icons.clear_outlined, size: 18),
                tooltip: 'Limpiar busqueda',
                onPressed: _clearSearch,
              )
            : null,
      ),
    );
  }

  Widget _buildSearchSummary(List<SettingSearchEntry> matches, NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMedium),
      child: Material(
        color: palette.surfaceSubtle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius),
          side: BorderSide(color: palette.border),
        ),
        child: Column(
          children: matches
              .map((SettingSearchEntry e) => ListTile(
                    dense: true,
                    title: Text(e.title),
                    subtitle: Text('${e.section.title} · ${e.subtitle}'),
                    trailing: StatusBadge(
                      label: e.section.title,
                      type: e.section.isRestricted ? BadgeType.pending : BadgeType.info,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  List<Widget> _buildMatchingSections(Set<SettingsSectionId> visible, NexIdPalette palette) {
    final OperatorUser? user = widget.sessionController.currentUser;
    final String place = widget.placesController.selectedPlace?.name ?? 'Punto no asignado';
    final Map<SettingsSectionId, Widget> sectionWidgets = <SettingsSectionId, Widget>{
      SettingsSectionId.appearance: ThemeAppearanceCard(controller: widget.settingsController),
      SettingsSectionId.accessibility: AccessibilityControlsCard(controller: widget.settingsController),
      SettingsSectionId.performance: LowEndPerformanceCard(controller: widget.settingsController),
      SettingsSectionId.storageCache: StorageAndCacheCard(
        controller: widget.settingsController,
        pendingSyncCount: widget.syncController.stats.pendingCount,
      ),
      SettingsSectionId.connectivitySync: ConnectivitySyncSettingsCard(
        settingsController: widget.settingsController,
        syncController: widget.syncController,
      ),
      SettingsSectionId.nfcRecords: NfcAndRecordsSettingsCard(controller: widget.settingsController),
      SettingsSectionId.notifications: NotificationsSettingsCard(controller: widget.settingsController),
      SettingsSectionId.privacySecurity: PrivacySecuritySettingsCard(
        user: user,
        placeName: place,
        onLogout: () => widget.sessionController.logout(),
      ),
      SettingsSectionId.appInfo: AppHardwareInfoCard(controller: widget.settingsController),
    };

    return <Widget>[
      for (final MapEntry<SettingsSectionId, Widget> entry in sectionWidgets.entries)
        if (visible.contains(entry.key)) _sectionBlock(entry.key, entry.value, palette),
      _sectionBlock(
        SettingsSectionId.advanced,
        AdvancedSettingsCard(
          settingsController: widget.settingsController,
          sessionController: widget.sessionController,
        ),
        palette,
      ),
    ];
  }

  Widget _sectionBlock(SettingsSectionId section, Widget child, NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spaceXSmall),
            child: Text(
              section.title,
              style: AppTypography.caption.copyWith(
                color: palette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildActionButtons(NexIdPalette palette) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.restore_outlined, size: 18),
            label: const Text('Restaurar ajustes'),
            onPressed: () => widget.settingsController.resetToDefaults(),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceSmall),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout_outlined, size: 18),
            label: const Text('Cerrar Sesion'),
            style: OutlinedButton.styleFrom(
              foregroundColor: palette.error,
              side: BorderSide(color: palette.error),
            ),
            onPressed: () => widget.sessionController.logout(),
          ),
        ),
      ],
    );
  }

  void _clearSearch() {
    _searchTextController.clear();
    widget.settingsController.setSearchQuery('');
  }
}
