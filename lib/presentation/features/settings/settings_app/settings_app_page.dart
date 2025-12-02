import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsAppPage extends ConsumerWidget {
  const SettingsAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: FText(
          L10n.of(context).settings_app_page__title,
          style: .bodyLarge,
        ),
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            children: [
              FTileGroup(
                items: [
                  FTile(
                    label: L10n.of(context).settings_app_page__theme_title,
                    icon: MdiIcons.formatPaint,
                    onTap: () => openThemePage(context),
                  ),
                  FTile(
                    label: L10n.of(context).settings_app_page__image_mode_title,
                    icon: MdiIcons.imageOutline,
                    onTap: () => openImageModePage(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openThemePage(BuildContext context) {
    context.routes.settingsAppTheme();
  }

  void openImageModePage(BuildContext context) {
    context.routes.settingsAppImageMode();
  }
}
