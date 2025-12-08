import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAccountDialogSettingsSection extends ConsumerWidget {
  const HomeAccountDialogSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTileGroup(
      items: [
        FTile(
          label: L10n.of(context).home_account_dialog_settings_section__title,
          subLabel:
              context.l10n.home_account_dialog_settings_section__title_hint,
          icon: MdiIcons.cog,
          iconColor: .green,
          onTap: () => openSettingsPage(context),
        ),
        FTile(
          label: L10n.of(
            context,
          ).btn_logout,
          subLabel:
              context.l10n.home_account_dialog_settings_section__logout_hint,
          icon: MdiIcons.logout,
          iconColor: .red,
          onTap: () => logout(ref),
        ),
      ],
    );
  }

  void openSettingsPage(BuildContext context) {
    context.routes.settingsApp();
  }

  void logout(WidgetRef ref) {
    ref.read(pAuthProvider.notifier).logout();
  }
}
