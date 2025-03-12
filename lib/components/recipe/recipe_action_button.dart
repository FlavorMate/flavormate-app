import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/recipes/p_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActionButton extends ConsumerWidget {
  final int recipeId;
  final VoidCallback edit;
  final VoidCallback delete;
  final VoidCallback transfer;

  const ActionButton({
    super.key,
    required this.recipeId,
    required this.edit,
    required this.delete,
    required this.transfer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pActionButtonProvider(recipeId));
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
          if (user.isAdmin)
            MenuItemButton(
              leadingIcon: Icon(MdiIcons.refresh),
              onPressed: transfer,
              child: Text(L10n.of(context).p_recipe_actions_transfer),
            ),
        ],
      ),
    );
  }
}
