import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class SettingsAccountPage extends ConsumerWidget {
  const SettingsAccountPage({super.key});

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(
        scrollController: null,
        title: context.l10n.settings_account_page__title,
      ),
      body: FProviderPage(
        provider: provider,
        onError: FEmptyMessage(
          title: context.l10n.settings_account_page__on_error,
          icon: IconConstants.errorIcon,
        ),
        builder: (context, data) {
          return FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                Row(
                  spacing: PADDING,
                  children: [
                    FCircleAvatar(
                      account: data,
                      radius: 35,
                    ),
                    SizedBox(
                      height: 70,
                      child: Column(
                        mainAxisSize: .max,
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .spaceEvenly,
                        children: [
                          FText(
                            data.displayName,
                            style: .titleLarge,
                            fontWeight: .bold,
                          ),
                          FText(data.email, style: .bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),

                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.settings_account_page__change_diet,
                      subLabel:
                          context.l10n.settings_account_page__change_diet_hint,

                      leading: const FTileIcon(icon: Symbols.eco_rounded),
                      onTap: () => manageDiet(context),
                    ),
                  ],
                ),
                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.settings_account_page__change_email,
                      subLabel:
                          context.l10n.settings_account_page__change_email_hint,

                      leading: const FTileIcon(icon: Symbols.mail_rounded),
                      onTap: () => manageEmail(context),
                    ),
                    FTile(
                      label:
                          context.l10n.settings_account_page__change_password,
                      subLabel: context
                          .l10n
                          .settings_account_page__change_password_hint,

                      leading: const FTileIcon(
                        icon: Symbols.password_rounded,
                      ),
                      onTap: () => managePassword(context),
                    ),
                  ],
                ),
                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.settings_account_page__sessions,
                      subLabel:
                          context.l10n.settings_account_page__sessions_hint,
                      leading: const FTileIcon(
                        icon: Symbols.key_rounded,
                      ),
                      onTap: () => manageSessions(context),
                    ),
                    FTile(
                      label: context.l10n.settings_account_page__oidc_links,
                      subLabel:
                          context.l10n.settings_account_page__oidc_links_hint,
                      leading: const FTileIcon(
                        icon: Symbols.link_2_rounded,
                      ),
                      onTap: () => manageOidcLinks(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void manageDiet(BuildContext context) {
    context.routes.settingsAccountDiet();
  }

  void manageEmail(BuildContext context) {
    context.routes.settingsAccountEmail();
  }

  void managePassword(BuildContext context) {
    context.routes.settingsAccountPassword();
  }

  void manageOidcLinks(BuildContext context) {
    context.routes.settingsAccountOidc();
  }

  void manageSessions(BuildContext context) {
    context.routes.settingsAccountSessions();
  }
}
