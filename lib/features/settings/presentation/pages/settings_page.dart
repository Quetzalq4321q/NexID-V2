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
import '../widgets/device_optimization_banner.dart';
import '../widgets/low_end_performance_card.dart';
import '../widgets/settings_system_sections.dart';
import '../widgets/theme_appearance_card.dart';

/// Pantalla 5: Configuracion con diseno visual definitivo (Encabezado,
/// buscador, tarjeta de Optimizacion del dispositivo y 8 categorias).
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.settingsController,
    required this.sessionController,
    required this.placesController,
    required this.syncController,
    this.onBackToPreviousTab,
  });

  final SettingsController settingsController;
  final SessionController sessionController;
  final PlacesController placesController;
  final SyncController syncController;
  final VoidCallback? onBackToPreviousTab;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _searchTextController;
  SettingsSectionId? _selectedSection;

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
        final double pad = widget.settingsController.compactDensity
            ? AppDimensions.spaceMedium
            : AppDimensions.spaceLarge;
        return PopScope(
          canPop: _selectedSection == null,
          onPopInvokedWithResult: (bool didPop, Object? _) {
            if (!didPop && _selectedSection != null) setState(() => _selectedSection = null);
          },
          child: Scaffold(
            backgroundColor: palette.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(pad),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: _selectedSection != null
                      ? _buildSectionDetailView(_selectedSection!, palette)
                      : _buildMainOverview(palette),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainOverview(NexIdPalette palette) {
    final bool canAdv = widget.sessionController.canAccessAdvancedSettings;
    final List<SettingSearchEntry> matches = widget.settingsController.searchSettings(canAccessAdvanced: canAdv);
    final bool hasQuery = widget.settingsController.searchQuery.trim().isNotEmpty;
    final Set<SettingsSectionId> matchedIds = matches.map((SettingSearchEntry e) => e.section).toSet();
    final List<SettingsSectionId> categories = SettingsSectionId.publicSections
        .where((SettingsSectionId s) => !hasQuery || matchedIds.contains(s))
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeaderBar(
          title: 'Configuracion',
          onBack: _handleHeaderBack,
          onSettingsIconTap: () => _openSection(SettingsSectionId.advanced),
        ),
        _buildSearchBar(hasQuery, palette),
        const SizedBox(height: AppDimensions.spaceMedium),
        DeviceOptimizationBannerCard(
          controller: widget.settingsController,
          onTap: () => _openSection(SettingsSectionId.performance),
        ),
        const SizedBox(height: AppDimensions.spaceMedium),
        if (hasQuery && matches.isNotEmpty) _buildSearchMatchesCard(matches, palette),
        if (hasQuery && matches.isEmpty)
          EmptyState(
            icon: Icons.search_off_outlined,
            message: 'Sin coincidencias en Ajustes para "${widget.settingsController.searchQuery}".',
            actionLabel: 'Limpiar busqueda',
            onAction: _clearSearch,
          )
        else if (categories.isNotEmpty)
          _buildCategoriesListCard(categories, palette),
      ],
    );
  }

  Widget _buildSearchBar(bool hasQuery, NexIdPalette palette) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: palette.border),
    );
    return TextField(
      key: const Key('settings_search_input'),
      controller: _searchTextController,
      onChanged: widget.settingsController.setSearchQuery,
      decoration: InputDecoration(
        hintText: 'Buscar un ajuste...',
        prefixIcon: const Icon(Icons.search_outlined, size: 20),
        filled: true,
        fillColor: palette.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: border,
        enabledBorder: border,
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

  Widget _buildSearchMatchesCard(List<SettingSearchEntry> matches, NexIdPalette palette) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMedium),
      child: Material(
        color: palette.surface,
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
                    onTap: () => _openSection(e.section),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCategoriesListCard(List<SettingsSectionId> categories, NexIdPalette palette) {
    return Material(
      color: palette.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        side: BorderSide(color: palette.border),
      ),
      child: Column(
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            if (i > 0) Divider(height: 1, color: palette.border),
            SettingsCategoryListTile(section: categories[i], onTap: () => _openSection(categories[i])),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionDetailView(SettingsSectionId section, NexIdPalette palette) {
    final OperatorUser? user = widget.sessionController.currentUser;
    final String place = widget.placesController.selectedPlace?.name ?? 'Punto no asignado';
    final SettingsController sCtrl = widget.settingsController;
    final Widget body = switch (section) {
      SettingsSectionId.appearance => ThemeAppearanceCard(controller: sCtrl),
      SettingsSectionId.accessibility => AccessibilityControlsCard(controller: sCtrl),
      SettingsSectionId.performance => LowEndPerformanceCard(controller: sCtrl),
      SettingsSectionId.storageCache => StorageAndCacheCard(
          controller: sCtrl, pendingSyncCount: widget.syncController.stats.pendingCount),
      SettingsSectionId.connectivitySync => ConnectivitySyncSettingsCard(
          settingsController: sCtrl, syncController: widget.syncController),
      SettingsSectionId.nfcRecords => NfcAndRecordsSettingsCard(controller: sCtrl),
      SettingsSectionId.privacySecurity => PrivacySecuritySettingsCard(
          user: user, placeName: place, onLogout: widget.sessionController.logout, onResetDefaults: sCtrl.resetToDefaults),
      SettingsSectionId.appInfo => AppHardwareInfoCard(
          controller: sCtrl, onOpenAdvanced: () => _openSection(SettingsSectionId.advanced)),
      SettingsSectionId.advanced => AdvancedSettingsCard(
          settingsController: sCtrl, sessionController: widget.sessionController),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsHeaderBar(
          title: section.title,
          onBack: () => setState(() => _selectedSection = null),
          onSettingsIconTap: () => _openSection(SettingsSectionId.advanced),
        ),
        Text(section.subtitle, style: AppTypography.caption.copyWith(color: palette.textSecondary)),
        const SizedBox(height: AppDimensions.spaceMedium),
        body,
      ],
    );
  }

  void _openSection(SettingsSectionId section) => setState(() => _selectedSection = section);
  void _handleHeaderBack() => Navigator.of(context).canPop() ? Navigator.of(context).pop() : widget.onBackToPreviousTab?.call();
  void _clearSearch() {
    _searchTextController.clear();
    widget.settingsController.setSearchQuery('');
  }
}
