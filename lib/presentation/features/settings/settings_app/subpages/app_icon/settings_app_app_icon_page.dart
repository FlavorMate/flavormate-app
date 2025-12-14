import 'dart:io';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/theme/utils/u_app_icon.dart';
import 'package:flavormate/generated/flutter_gen/assets.gen.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class SettingsAppAppIconPage extends StatelessWidget {
  const SettingsAppAppIconPage({super.key});

  bool get _notSupported => kIsWeb ||
      !Platform.isAndroid && !Platform.isIOS && !Platform.isMacOS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.settings_app_app_icon_page__title,
      ),
      body: SafeArea(
        child: FResponsive(
          child: Column(
            spacing: PADDING,
            children: [
              if (_notSupported)
                FCard(
                  color: context.colorScheme.primaryContainer,
                  child: Row(
                    spacing: PADDING,
                    children: [
                      const Icon(MdiIcons.alertCircleOutline),
                      Expanded(
                        child: FText(
                          context.l10n.settings_app_app_icon_page__hint,
                          style: .bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              FTileGroup(
                items: [
                  _buildTile(
                    imagePath: Assets.appIcons.flavormate.path,
                    label: context
                        .l10n
                        .settings_app_app_icon_page__icon_flavormate,
                    onTap: () => setIcon(context, .appIcon),
                  ),
                  _buildTile(
                    imagePath: Assets.appIcons.winter2025.path,
                    label: context
                        .l10n
                        .settings_app_app_icon_page__icon_winter_2025,
                    onTap: () => setIcon(context, .winter2025),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setIcon(BuildContext context, AppIcon icon) async {
    if (_notSupported) return;

    context.showLoadingDialog();

    bool success = true;
    try {
      await UAppIcon.changeIcon(icon);
    } catch (e) {
      success = false;
    }

    if (!context.mounted) return;
    context.pop();

    if (success) {
      context.showTextSnackBar(
        context.l10n.settings_app_app_icon_page__on_success,
      );
    } else {
      context.showErrorSnackBar(
        context.l10n.settings_app_app_icon_page__on_error,
      );
    }
  }

  FTile _buildTile({
    required String label,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    const iconHeight = 56.0;

    return FTile(
      height: iconHeight + 2 * PADDING,
      leading: ClipRRect(
        borderRadius: .circular(BORDER_RADIUS),
        child: Image.asset(imagePath, height: iconHeight),
      ),
      label: label,
      subLabel: null,
      onTap: onTap,
    );
  }
}
