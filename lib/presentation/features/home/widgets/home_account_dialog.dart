import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_account_section.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_admin_section.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_info_section.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAccountDialog extends StatelessWidget {
  const HomeAccountDialog({super.key});

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      onError: FEmptyMessage(
        title: L10n.of(context).home_account_dialog__on_error,
        icon: StateIconConstants.authors.errorIcon,
      ),
      builder: (context, account) {
        final size = MediaQuery.sizeOf(context);
        final width = size.width > FBreakpoint.smValue ? 450.0 : null;

        return Align(
          alignment: .centerRight,
          child: SizedBox(
            width: width,
            child: Center(
              child: Scaffold(
                appBar: FAppBar(
                  automaticallyImplyLeading: false,
                  title: account.username,
                  actions: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(MdiIcons.close),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: FResponsive(
                    child: Column(
                      spacing: PADDING,
                      children: [
                        HomeAccountDialogAccountSection(account: account),

                        FTileGroup(
                          items: [
                            FTile(
                              label: L10n.of(
                                context,
                              ).home_account_dialog__my_profile,
                              icon: MdiIcons.accountOutline,
                              onTap: () => openAccount(context, account.id),
                            ),
                          ],
                        ),

                        const HomeAccountDialogSettingsSection(),

                        if (account.isAdmin)
                          const HomeAccountDialogAdminSection(),

                        const HomeAccountDialogInfoSection(),

                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            TextButton(
                              onPressed: openGitHub,
                              child: const Text('GitHub'),
                            ),
                            const Text('-'),
                            TextButton(
                              onPressed: () => openLicenses(context),
                              child: Text(
                                L10n.of(
                                  context,
                                ).home_account_dialog__licenses,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void openAccount(BuildContext context, String id) {
    context.pop();
    context.routes.accountsItem(id);
  }

  void openGitHub() async {
    await launchUrl(
      Uri.parse('https://github.com/flavormate/flavormate-app'),
      mode: .externalApplication,
    );
  }

  void openLicenses(
    BuildContext context,
  ) {
    showLicensePage(
      context: context,
      applicationName: 'FlavorMate',
    );
  }
}
