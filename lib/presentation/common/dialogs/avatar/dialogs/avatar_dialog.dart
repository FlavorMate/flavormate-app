import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/avatar/models/avatar_dialog_result.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class AvatarDialog extends StatelessWidget {
  const AvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.avatar_dialog__title,
      child: FTileGroup(
        items: [
          FTile(
            label: context.l10n.avatar_dialog__change,
            subLabel: context.l10n.avatar_dialog__change_hint,
            leading: const FTileIcon(icon: MdiIcons.accountPlus),
            onTap: () => pop(context, .Change),
          ),
          FTile(
            label: context.l10n.avatar_dialog__delete,
            subLabel: context.l10n.avatar_dialog__delete_hint,
            leading: const FTileIcon(icon: MdiIcons.accountMinus),
            onTap: () => pop(context, .Delete),
          ),
        ],
      ),
    );
  }

  void pop(BuildContext context, AvatarDialogResult value) {
    context.pop(value);
  }
}
