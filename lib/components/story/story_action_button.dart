import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/stories/p_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryActionButton extends ConsumerWidget {
  final int storyId;
  final VoidCallback edit;
  final VoidCallback delete;

  const StoryActionButton({
    super.key,
    required this.storyId,
    required this.edit,
    required this.delete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pActionButtonProvider(storyId));
    return RStruct(
      provider,
      (_, user) => MenuAnchor(
        builder:
            (_, controller, widget) => IconButton(
              icon: Icon(MdiIcons.dotsVertical),
              onPressed:
                  () =>
                      controller.isOpen
                          ? controller.close()
                          : controller.open(),
            ),
        menuChildren: [
          if (user.isOwner)
            MenuItemButton(
              leadingIcon: Icon(MdiIcons.pencil),
              onPressed: edit,
              child: Text(L10n.of(context).p_recipe_actions_edit),
            ),
          if (user.isOwner || user.isAdmin)
            MenuItemButton(
              leadingIcon: Icon(MdiIcons.trashCan),
              onPressed: delete,
              child: Text(L10n.of(context).p_recipe_actions_delete),
            ),
        ],
      ),
    );
  }
}
