import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class HomeAccountDialogSettingsSection extends ConsumerWidget {
  const HomeAccountDialogSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FTileGroup(
      items: [
        FTile(
          label: context.l10n.home_account_dialog_settings_section__title,
          subLabel:
              context.l10n.home_account_dialog_settings_section__title_hint,
          leading: const FTileIcon(icon: Symbols.settings_rounded),

          onTap: () => openSettingsPage(context),
        ),
        FTile(
          label: context.l10n.btn_logout,
          subLabel:
              context.l10n.home_account_dialog_settings_section__logout_hint,
          leading: const FTileIcon(icon: Symbols.logout_rounded),
          onTap: () => logout(ref),
        ),
      ],
    );
  }

  void openSettingsPage(BuildContext context) {
    context.pop();
    context.routes.settingsApp();
  }

  void logout(WidgetRef ref) {
    ref.read(pAuthProvider.notifier).logout();
  }
}
