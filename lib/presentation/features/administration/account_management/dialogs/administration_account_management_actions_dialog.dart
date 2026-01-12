import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flavormate/presentation/features/administration/account_management/enums/administration_account_management_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class AdministrationAccountManagementActionsDialog extends StatelessWidget {
  final AccountFullDto account;
  final bool isCurrent;

  const AdministrationAccountManagementActionsDialog({
    super.key,
    required this.account,
    required this.isCurrent,
  });

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
                leading: const FTileIcon(icon: MdiIcons.account),
                onTap: () => pop(context, .Open),
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_avatar,
                subLabel: null,
                leading: const FTileIcon(icon: MdiIcons.image),
                onTap: () => pop(context, .Avatar),
                disabled: account.avatar == null,
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
                leading: const FTileIcon(icon: MdiIcons.accountCheck),
                onTap: () => pop(context, .Enable),
                disabled: isCurrent,
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_set_password,
                subLabel: null,
                leading: const FTileIcon(icon: MdiIcons.lockReset),
                onTap: () => pop(context, .ResetPassword),
              ),
              FTile(
                label: context
                    .l10n
                    .administration_account_management_actions_dialog__actions_delete,
                subLabel: null,
                leading: const FTileIcon(icon: MdiIcons.delete),
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
