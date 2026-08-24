import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_account_section.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_info_section.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/home_account_dialog_settings_section.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeAccountDialog extends StatelessWidget {
  const HomeAccountDialog({super.key});

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      onError: FEmptyMessage(
        title: context.l10n.home_account_dialog__on_error,
        icon: IconConstants.errorIcon,
      ),
      builder: (context, account) {
        final size = MediaQuery.sizeOf(context);
        final width = size.width > FBreakpoint.smValue ? 450.0 : null;

        return Stack(
          fit: .expand,
          children: [
            GestureDetector(
              behavior: .opaque,
              onTapUp: (details) => handleBackgroundPop(context, details),
              child: const SizedBox.expand(),
            ),
            Align(
              alignment: .centerRight,
              child: SizedBox(
                width: width,
                child: Center(
                  child: Scaffold(
                    appBar: FAppBar(
                      automaticallyImplyLeading: false,
                      scrollController: null,
                      title: account.username,
                      actions: [
                        M3EIconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Symbols.close_rounded),
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
                                  label: context
                                      .l10n
                                      .home_account_dialog__my_profile,
                                  subLabel: context
                                      .l10n
                                      .home_account_dialog__my_profile_hint,
                                  leading: const FTileIcon(
                                    icon: Symbols.person_rounded,
                                  ),
                                  onTap: () => openAccount(context, account.id),
                                ),
                              ],
                            ),

                            const HomeAccountDialogSettingsSection(),

                            const HomeAccountDialogInfoSection(),

                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                M3EButton(
                                  style: .text,
                                  onPressed: openGitHub,
                                  child: const Text('GitHub'),
                                ),
                                const Text('-'),
                                M3EButton(
                                  style: .text,
                                  onPressed: () => openLicenses(context),
                                  child: Text(
                                    context.l10n.home_account_dialog__licenses,
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
            ),
          ],
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

  void handleBackgroundPop(BuildContext context, TapUpDetails? details) {
    if (details?.globalPosition != Offset.zero) {
      context.pop();
    }
  }
}
