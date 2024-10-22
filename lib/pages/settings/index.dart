import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/settings/dialogs/d_changelog.dart';
import 'package:flavormate/components/settings/dialogs/d_theme.dart';
import 'package:flavormate/components/settings/dialogs/manage_avatar.dart';
import 'package:flavormate/components/settings/dialogs/manage_diet.dart';
import 'package:flavormate/components/settings/dialogs/manage_mail.dart';
import 'package:flavormate/components/settings/dialogs/manage_password.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/file/file_draft.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const _version =
      String.fromEnvironment('build.stage', defaultValue: '-');

  final double _buttonWidth = 350;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(pUserProvider);
    final infoProvider = ref.watch(pPackageInfoProvider);
    final serverProvider = ref.watch(pServerProvider);
    return TResponsive(
      child: TColumn(
        children: [
          RStruct(
            userProvider,
            (_, user) => TCard(
              padding: 0,
              child: TColumn(
                children: [
                  Container(
                    height: 128,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(BORDER_RADIUS),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: TRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      space: PADDING,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(BORDER_RADIUS),
                              child: user.avatar != null
                                  ? TImage(
                                      imageSrc: user.avatar?.path(
                                          context.read(pServerProvider)!),
                                      type: TImageType.network,
                                      height: 64,
                                      width: 64,
                                    )
                                  : Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      height: 64,
                                      width: 64,
                                      child: Center(
                                        child: TText(
                                          user.displayName[0],
                                          TextStyles.headlineLarge,
                                          color: TextColor.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TColumn(
                            space: PADDING / 2,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TText(
                                user.displayName,
                                TextStyles.titleLarge,
                                color: TextColor.filledButton,
                              ),
                              TText(
                                '@${user.username}',
                                TextStyles.titleSmall,
                                color: TextColor.filledButton,
                              ),
                              TText(
                                '☁ $serverProvider',
                                TextStyles.bodySmall,
                                color: TextColor.filledButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: PADDING),
                    child: TColumn(children: [
                      TIconButton(
                        onPressed: () => manageAvatar(context, ref),
                        icon: MdiIcons.accountCircleOutline,
                        label: L10n.of(context).p_settings_manage_avatar,
                        width: _buttonWidth,
                      ),
                      TIconButton(
                        onPressed: () => manageDiet(context, ref, user.diet!),
                        icon: MdiIcons.foodOutline,
                        label: L10n.of(context).p_settings_manage_diet,
                        width: _buttonWidth,
                      ),
                      TIconButton(
                        onPressed: () => manageMail(context, ref, user.mail),
                        icon: MdiIcons.emailOutline,
                        label: L10n.of(context).p_settings_change_mail,
                        width: _buttonWidth,
                      ),
                      TIconButton(
                        onPressed: () => managePassword(context, ref),
                        icon: MdiIcons.formTextboxPassword,
                        label: L10n.of(context).p_settings_change_password,
                        width: _buttonWidth,
                      ),
                      TIconButton(
                        onPressed: ref.read(pAuthStateProvider.notifier).logout,
                        icon: MdiIcons.logout,
                        label: L10n.of(context).p_settings_logout,
                        width: _buttonWidth,
                      ),
                    ]),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
          TCard(
            padding: PADDING,
            child: TColumn(
              children: [
                TText(L10n.of(context).p_settings_informations_title,
                    TextStyles.headlineMedium),
                TIconButton(
                  onPressed: () => showChangelog(context),
                  icon: MdiIcons.arrowUpBoldCircleOutline,
                  label: L10n.of(context).p_settings_whats_new,
                  width: _buttonWidth,
                ),
                RStruct(
                  infoProvider,
                  (_, info) => TIconButton(
                    onPressed: () {},
                    icon: MdiIcons.informationOutline,
                    label: '${info.version} ($_version)',
                    width: _buttonWidth,
                  ),
                ),
              ],
            ),
          ),
          TCard(
            padding: PADDING,
            child: TColumn(
              children: [
                TText(L10n.of(context).p_settings_misc,
                    TextStyles.headlineMedium),
                TIconButton(
                  onPressed: () => showThemePicker(context, ref),
                  icon: MdiIcons.formatPaint,
                  label: L10n.of(context).d_settings_theme_title,
                  width: _buttonWidth,
                ),
              ],
            ),
          ),
          RStruct(
            userProvider,
            (_, user) => Visibility(
              visible: user.isAdmin,
              child: TCard(
                padding: PADDING,
                child: TColumn(
                  children: [
                    Text(
                      L10n.of(context).p_settings_administration_title,
                      style: const TextStyle(fontSize: 24),
                    ),
                    TIconButton(
                      onPressed: () => context.pushNamed('user_management'),
                      icon: MdiIcons.account,
                      label: L10n.of(context).p_settings_user_management,
                      width: _buttonWidth,
                    ),
                    TIconButton(
                      onPressed: () => context.showTextSnackBar('Coming soon'),
                      icon: MdiIcons.bookOutline,
                      label: L10n.of(context).p_settings_recipe_management,
                      width: _buttonWidth,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  manageAvatar(BuildContext context, WidgetRef ref) async {
    final user = await ref.read(pUserProvider.future);

    if (!context.mounted) return;
    final response = await showDialog<String>(
      context: context,
      builder: (_) => const ManageAvatar(),
    );

    if (response == 'delete') {
      await ref.read(pApiProvider).filesClient.deleteById(user.avatar!.id!);
      ref.invalidate(pUserProvider);
    } else if (response == 'change') {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final bytes = await image.readAsBytes();

      final cropped = UImage.resizeImage(bytes: bytes, width: 512, height: 512);

      final file = FileDraft(
        id: -1,
        type: 'IMAGE',
        category: 'ACCOUNT',
        owner: user.id!,
        name: user.username,
        content: cropped,
      );

      final fileResponse = await ref.read(pApiProvider).filesClient.create(
            data: file.toMap(),
          );

      await ref
          .read(pApiProvider)
          .userClient
          .update(user.id!, data: {'avatar': fileResponse.toMap()});

      ref.invalidate(pUserProvider);
    }
  }

  manageDiet(BuildContext context, WidgetRef ref, Diet current) async {
    final response = await showDialog<Diet>(
      context: context,
      builder: (_) => const ManageDiet(),
    );

    if (response == null || response == current) return;

    ref.read(pUserProvider.notifier).setDiet(response);
  }

  manageMail(BuildContext context, WidgetRef ref, String? current) async {
    final response = await showDialog<String>(
      context: context,
      builder: (_) => ManageMail(mail: current),
    );

    if (response == null || response == current) return;

    if (await ref.read(pUserProvider.notifier).setMail(response)) {
      if (!context.mounted) return;
      context.showTextSnackBar(
        L10n.of(context).d_settings_manage_mail_success,
      );
    } else {
      if (!context.mounted) return;
      context.showTextSnackBar(
        L10n.of(context).d_settings_manage_mail_error,
      );
    }
  }

  managePassword(BuildContext context, WidgetRef ref) async {
    final response = await showDialog<Map>(
      context: context,
      builder: (_) => const ManagePassword(),
    );

    if (response == null) return;
    if (await ref.read(pUserProvider.notifier).setPassword(response)) {
      if (!context.mounted) return;
      context.showTextSnackBar(
        L10n.of(context).d_settings_manage_password_success,
      );
    } else {
      if (!context.mounted) return;
      context.showTextSnackBar(
        L10n.of(context).d_settings_manage_password_error,
      );
    }
  }

  Future<void> showThemePicker(BuildContext context, WidgetRef ref) async {
    await showDialog(
      context: context,
      builder: (_) => const DTheme(),
      useSafeArea: false,
    );
  }

  void showChangelog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const DChangelog(),
      useSafeArea: false,
    );
  }
}
