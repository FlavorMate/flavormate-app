import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/avatar/models/avatar_dialog_result.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:material_ui/material_ui.dart';

class AvatarDialog extends StatelessWidget {
  const AvatarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.avatar_dialog__title,
      child: FTileGroup(
        backgroundColor: context.colorScheme.surfaceContainerLow,
        items: [
          FTile(
            label: context.l10n.avatar_dialog__change,
            subLabel: context.l10n.avatar_dialog__change_hint,
            leading: const FTileIcon(icon: Symbols.person_add_rounded),
            onTap: () => pop(context, .Change),
          ),
          FTile(
            label: context.l10n.avatar_dialog__delete,
            subLabel: context.l10n.avatar_dialog__delete_hint,
            leading: const FTileIcon(icon: Symbols.person_remove_rounded),
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
