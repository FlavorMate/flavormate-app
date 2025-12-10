import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/settings/settings_account/dialogs/settings_account_diet_dialog.dart';
import 'package:flavormate/presentation/features/settings/settings_account/dialogs/settings_account_email_dialog.dart';
import 'package:flavormate/presentation/features/settings/settings_account/dialogs/settings_account_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountPage extends ConsumerWidget {
  const SettingsAccountPage({super.key});

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(MdiIcons.close),
        ),
        title: FText(
          context.l10n.settings_account_page__title,
          style: .bodyLarge,
        ),
      ),
      body: FProviderPage(
        provider: provider,
        onError: FEmptyMessage(
          title: context.l10n.settings_account_page__on_error,
          icon: StateIconConstants.authors.errorIcon,
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
                            weight: .bold,
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
                      icon: MdiIcons.food,
                      iconColor: .red,
                      onTap: () => manageDiet(context, ref, data.diet),
                    ),
                  ],
                ),
                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.settings_account_page__change_email,
                      subLabel:
                          context.l10n.settings_account_page__change_email_hint,
                      icon: MdiIcons.email,
                      iconColor: .orange,
                      onTap: () => manageEmail(context, ref, data.email),
                    ),
                    FTile(
                      label:
                          context.l10n.settings_account_page__change_password,
                      subLabel: context
                          .l10n
                          .settings_account_page__change_password_hint,
                      icon: MdiIcons.formTextboxPassword,
                      iconColor: .yellow,
                      onTap: () => managePassword(context, ref),
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

  Future<void> manageDiet(
    BuildContext context,
    WidgetRef ref,
    Diet current,
  ) async {
    final response = await showDialog<AccountUpdateDto>(
      context: context,
      builder: (_) => SettingsAccountDietDialog(currentDiet: current),
    );

    if (!context.mounted || response == null || response.diet == current) {
      return;
    }

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).putAccountsId(response);

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_diet_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_diet_failure,
      );
    }
  }

  Future<void> manageEmail(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final response = await showDialog<AccountUpdateDto>(
      context: context,
      builder: (_) => const SettingsAccountEmailDialog(),
    );

    if (!context.mounted || response == null || response.email == current) {
      return;
    }

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).putAccountsId(response);

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_email_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_email_failure,
      );
    }
  }

  Future<void> managePassword(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<AccountUpdateDto>(
      context: context,
      builder: (_) => const SettingsAccountPasswordDialog(),
    );

    if (!context.mounted || response == null) return;

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).putAccountsId(response);

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_password_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.settings_account_page__change_password_failure,
      );
    }
  }
}
