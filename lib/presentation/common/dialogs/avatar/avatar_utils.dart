import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id.dart';
import 'package:flavormate/presentation/common/dialogs/avatar/dialogs/avatar_dialog.dart';
import 'package:flavormate/presentation/common/dialogs/avatar/models/avatar_dialog_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

abstract class AvatarUtils {
  static Future<void> manageAvatar(
    BuildContext context,
    WidgetRef ref,
    AccountDto account,
  ) async {
    if (!context.mounted) return;
    final response = await showDialog<AvatarDialogResult>(
      context: context,
      builder: (_) => const AvatarDialog(),
    );

    if (response == null) return;

    final provider = pRestAccountsIdProvider(account.id);

    if (response == .Delete) {
      await ref.read(provider.notifier).deleteAvatar();
    } else if (response == .Change) {
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
          context.l10n.avatar_utils__change_avatar_success,
        );
      } else {
        context.showTextSnackBar(
          context.l10n.avatar_utils__change_avatar_failure,
        );
      }
    }
  }
}
