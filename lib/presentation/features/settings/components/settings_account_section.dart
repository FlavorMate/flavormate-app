import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/features/accounts/account_file_dto.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_image_ink_well.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/settings/dialogs/settings_change_avatar_dialog.dart';
import 'package:flavormate/presentation/features/settings/dialogs/settings_change_diet_dialog.dart';
import 'package:flavormate/presentation/features/settings/dialogs/settings_change_email_dialog.dart';
import 'package:flavormate/presentation/features/settings/dialogs/settings_change_password_dialog.dart';
import 'package:flavormate/presentation/features/settings/enums/settings_change_avatar_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SettingsAccountSection extends ConsumerWidget {
  const SettingsAccountSection({super.key});

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(pSPCurrentServerProvider);
    return FProviderStruct(
      provider: provider,
      builder: (_, account) => FCard(
        padding: 0,
        child: Column(
          spacing: PADDING,
          children: [
            Container(
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: PADDING,
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: FImageInkWell(
                        height: 64,
                        width: 64,
                        child: FCircularAvatarViewer(account: account),
                        onTap: () => showAvatar(context, account.avatar!),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      spacing: PADDING / 2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FText(
                          account.displayName,
                          style: FTextStyle.titleLarge,
                          color: FTextColor.filledButton,
                        ),
                        FText(
                          '@${account.username}',
                          style: FTextStyle.titleSmall,
                          color: FTextColor.filledButton,
                        ),
                        FText(
                          '☁ ${server!}',
                          style: FTextStyle.bodySmall,
                          color: FTextColor.filledButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: PADDING),
              child: Column(
                spacing: PADDING,
                children: [
                  FIconButton(
                    onPressed: () => manageAvatar(context, ref),
                    icon: MdiIcons.accountCircleOutline,
                    label: L10n.of(
                      context,
                    ).settings_account_section__change_avatar,
                    width: BUTTON_WIDTH,
                  ),
                  FIconButton(
                    onPressed: () => manageDiet(context, ref, account.diet),
                    icon: MdiIcons.foodOutline,
                    label: L10n.of(
                      context,
                    ).settings_account_section__change_diet,
                    width: BUTTON_WIDTH,
                  ),
                  FIconButton(
                    onPressed: () => manageEmail(context, ref, account.email),
                    icon: MdiIcons.emailOutline,
                    label: L10n.of(
                      context,
                    ).settings_account_section__change_email,
                    width: BUTTON_WIDTH,
                  ),
                  FIconButton(
                    onPressed: () => managePassword(context, ref),
                    icon: MdiIcons.formTextboxPassword,
                    label: L10n.of(
                      context,
                    ).settings_account_section__change_password,
                    width: BUTTON_WIDTH,
                  ),
                  FIconButton(
                    onPressed: ref.read(pAuthProvider.notifier).logout,
                    icon: MdiIcons.logout,
                    label: L10n.of(context).btn_logout,
                    width: BUTTON_WIDTH,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PADDING / 4),
          ],
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).settings_account_section__on_error,
        icon: StateIconConstants.authors.errorIcon,
      ),
    );
  }

  Future<void> manageAvatar(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;
    final response = await showDialog<SettingsChangeAvatarResult>(
      context: context,
      builder: (_) => const SettingsChangeAvatarDialog(),
    );

    if (response == SettingsChangeAvatarResult.Delete) {
      await ref.read(provider.notifier).deleteAvatar();
    } else if (response == SettingsChangeAvatarResult.Change) {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image == null || !context.mounted) return;

      context.showLoadingDialog();

      final bytes = await image.readAsBytes();

      final result = await ref.read(provider.notifier).updateAvatar(bytes);

      if (!context.mounted) return;
      context.pop();

      if (!result.hasError) {
        context.showTextSnackBar(
          L10n.of(context).settings_account_section__change_avatar_success,
        );
      } else {
        context.showTextSnackBar(
          L10n.of(context).settings_account_section__change_avatar_failure,
        );
      }
    }
  }

  Future<void> manageDiet(
    BuildContext context,
    WidgetRef ref,
    Diet current,
  ) async {
    final response = await showDialog<AccountUpdateDto>(
      context: context,
      builder: (_) => SettingsChangeDietDialog(currentDiet: current),
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
        L10n.of(context).settings_account_section__change_diet_success,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).settings_account_section__change_diet_failure,
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
      builder: (_) => const SettingsChangeEmailDialog(),
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
        L10n.of(context).settings_account_section__change_email_success,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).settings_account_section__change_email_failure,
      );
    }
  }

  Future<void> managePassword(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<AccountUpdateDto>(
      context: context,
      builder: (_) => const SettingsChangePasswordDialog(),
    );

    if (!context.mounted || response == null) return;

    context.showLoadingDialog();

    final result = await ref.read(provider.notifier).putAccountsId(response);

    if (!context.mounted) return;
    context.pop();

    if (!result.hasError) {
      context.showTextSnackBar(
        L10n.of(context).settings_account_section__change_password_success,
      );
    } else {
      context.showTextSnackBar(
        L10n.of(context).settings_account_section__change_password_failure,
      );
    }
  }

  void showAvatar(
    BuildContext context,
    AccountFileDto avatar,
  ) {
    context.showFullscreenImage(avatar.url(ImageSquareResolution.Original));
  }
}
