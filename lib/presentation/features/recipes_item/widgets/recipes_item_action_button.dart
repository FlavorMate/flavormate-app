import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class RecipesItemActionButton extends ConsumerWidget {
  final bool isOwner;
  final bool isAdmin;

  final VoidCallback edit;
  final VoidCallback delete;
  final VoidCallback transfer;

  const RecipesItemActionButton({
    super.key,
    required this.isOwner,
    required this.isAdmin,
    required this.edit,
    required this.delete,
    required this.transfer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return M3EMenu.entries(
      anchorBuilder: (_, open) => M3EIconButton(
        icon: const Icon(Symbols.more_vert_rounded),
        onPressed: open,
      ),
      entries: [
        if (isOwner || isAdmin)
          M3EMenuEntry(
            leading: const Icon(Symbols.edit_rounded),
            onPressed: edit,
            label: context.l10n.recipes_item_action_button__edit,
          ),
        if (isOwner || isAdmin)
          M3EMenuEntry(
            leading: const Icon(Symbols.delete_rounded),
            onPressed: delete,
            label: context.l10n.recipes_item_action_button__delete,
            isDestructive: true,
          ),
        if (isAdmin)
          M3EMenuEntry(
            leading: const Icon(Symbols.refresh_rounded),
            onPressed: transfer,
            label: context.l10n.recipes_item_action_button__transfer,
          ),
      ],
    );
  }
}
