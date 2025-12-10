import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/dialogs/home_account_dialog_avatar_dialog.dart';
import 'package:flavormate/presentation/features/home/widgets/account_dialog/enums/home_account_dialog_avatar_result.dart';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class HomeAccountDialogAccountSection extends ConsumerWidget {
  final AccountFullDto account;

  PRestAccountsSelfProvider get provider => pRestAccountsSelfProvider;

  const HomeAccountDialogAccountSection({super.key, required this.account});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        FCircleAvatar(
          account: account,
          radius: 45,
          onTap: () => manageAvatar(context, ref),
          child: const Positioned(
            bottom: 3,
            right: 3,
            child: CircleAvatar(
              radius: 12,
              child: Icon(
                MdiIcons.cameraOutline,
                size: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: PADDING / 2),
        Center(
          child: FText(
            context.l10n.home_account_dialog_account_section__headline(
              account.displayName,
            ),
            style: .titleLarge,
          ),
        ),
        const SizedBox(height: PADDING),
        OutlinedButton(
          onPressed: () => openSettingsAccount(context),
          child: Text(
            context.l10n.home_account_dialog_account_section__manage_account,
          ),
        ),
      ],
    );
  }

  Future<void> manageAvatar(BuildContext context, WidgetRef ref) async {
    if (!context.mounted) return;
    final response = await showDialog<HomeAccountDialogAvatarResult>(
      context: context,
      builder: (_) => const HomeAccountDialogAvatarDialog(),
    );

    if (response == HomeAccountDialogAvatarResult.Delete) {
      await ref.read(provider.notifier).deleteAvatar();
    } else if (response == HomeAccountDialogAvatarResult.Change) {
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
          context.l10n.home_account_dialog_account_section__change_password,
        );
      } else {
        context.showTextSnackBar(
          context
              .l10n
              .home_account_dialog_account_section__change_avatar_failure,
        );
      }
    }
  }

  void openSettingsAccount(BuildContext context) {
    context.pop();
    context.routes.settingsAccount();
  }
}
