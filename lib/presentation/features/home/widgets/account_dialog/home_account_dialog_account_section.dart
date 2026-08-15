import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/core/utils/avatar_utils.dart';
import 'package:flavormate/presentation/common/widgets/f_circle_avatar.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
                Symbols.camera_alt_rounded,
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
        M3EButton(
          style: .outlined,
          onPressed: () => openSettingsAccount(context),
          child: Text(
            context.l10n.home_account_dialog_account_section__manage_account,
          ),
        ),
      ],
    );
  }

  Future<void> manageAvatar(BuildContext context, WidgetRef ref) async {
    await AvatarUtils.manageAvatar(context, ref, account);
  }

  void openSettingsAccount(BuildContext context) {
    context.pop();
    context.routes.settingsAccount();
  }
}
