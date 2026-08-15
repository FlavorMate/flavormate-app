import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class StoriesItemActionButton extends StatelessWidget {
  final bool isAdmin;
  final bool isOwner;

  final VoidCallback edit;
  final VoidCallback delete;

  const StoriesItemActionButton({
    super.key,
    required this.isAdmin,
    required this.isOwner,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
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
            label: context.l10n.stories_item_action_button__edit,
          ),
        if (isOwner || isAdmin)
          M3EMenuEntry(
            leading: const Icon(Symbols.delete_rounded),
            onPressed: delete,
            isDestructive: true,
            label: context.l10n.stories_item_action_button__delete,
          ),
      ],
    );
  }
}
