import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flavormate/presentation/features/administration/account_management/enums/administration_account_management_actions.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class AdministrationAccountManagementActionsDialog extends StatelessWidget {
  final AccountFullDto account;
  final bool isCurrent;

  const AdministrationAccountManagementActionsDialog({
    super.key,
    required this.account,
    required this.isCurrent,
  });

  static Future<AdministrationAccountManagementActions?> openDialog(
    BuildContext context, {
    required AccountFullDto account,
    required bool isCurrent,
  }) async {
    return await openAlertDialog(
      context,
      dialog: AdministrationAccountManagementActionsDialog(
        account: account,
        isCurrent: isCurrent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context
          .l10n
          .administration_account_management_actions_dialog__actions_title,
      child: Column(
        mainAxisSize: .min,
        spacing: PADDING,
        children: [
          FTileGroup(
            items: [
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_open,
                subLabel: null,
                leading: const FTileIcon(icon: Symbols.person_rounded),
                onTap: () => pop(context, .Open),
              ),
            ],
          ),
          FTileGroup(
            items: [
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_avatar,
                subLabel: null,
                leading: const FTileIcon(icon: Symbols.image_rounded),
                onTap: () => pop(context, .Avatar),
                disabled: account.avatar == null,
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_avatar_change,
                subLabel: null,
                leading: const FTileIcon(
                  icon: Symbols.add_photo_alternate_rounded,
                ),
                onTap: () => pop(context, .AvatarChange),
              ),
            ],
          ),
          FTileGroup(
            items: [
              FTile(
                label: account.enabled
                    ? context
                          .l10n
                          .administration_account_management_actions_dialog__actions_disable
                    : context
                          .l10n
                          .administration_account_management_actions_dialog__actions_enable,
                subLabel: null,
                leading: FTileIcon(
                  icon: account.enabled
                      ? Symbols.person_remove_rounded
                      : Symbols.person_check_rounded,
                ),
                onTap: () => pop(context, .Enable),
                disabled: isCurrent,
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_set_password,
                subLabel: null,
                leading: const FTileIcon(icon: Symbols.lock_reset_rounded),
                onTap: () => pop(context, .ResetPassword),
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_delete,
                subLabel: null,
                leading: const FTileIcon(icon: Symbols.delete_rounded),
                onTap: () => pop(context, .Delete),
                disabled: isCurrent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void pop(BuildContext context, AdministrationAccountManagementActions value) {
    context.pop(value);
  }
}
