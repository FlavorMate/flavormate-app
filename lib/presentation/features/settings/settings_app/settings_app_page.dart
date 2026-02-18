import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsAppPage extends ConsumerStatefulWidget {
  const SettingsAppPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsAppPageState();
}

class _SettingsAppPageState extends ConsumerState<SettingsAppPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        scrollController: _scrollController,
        title: context.l10n.settings_app_page__title,
      ),
      body: SafeArea(
        child: FResponsive(
          controller: _scrollController,
          child: Column(
            children: [
              FTileGroup(
                items: [
                  FTile(
                    label: context.l10n.settings_app_page__app_icon_title,
                    subLabel:
                        context.l10n.settings_app_page__app_icon_title_hint,

                    leading: const FTileIcon(icon: MdiIcons.palette),
                    onTap: () => openAppIconPage(context),
                  ),
                  FTile(
                    label: context.l10n.settings_app_page__image_mode_title,
                    subLabel:
                        context.l10n.settings_app_page__image_mode_title_hint,

                    leading: const FTileIcon(icon: MdiIcons.image),
                    onTap: () => openImageModePage(context),
                  ),
                  FTile(
                    label: context.l10n.settings_app_page__theme_title,
                    subLabel: context.l10n.settings_app_page__theme_title_hint,

                    leading: const FTileIcon(icon: MdiIcons.formatPaint),
                    onTap: () => openThemePage(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openAppIconPage(BuildContext context) {
    context.routes.settingsAppAppIcon();
  }

  void openImageModePage(BuildContext context) {
    context.routes.settingsAppImageMode();
  }

  void openThemePage(BuildContext context) {
    context.routes.settingsAppTheme();
  }
}
