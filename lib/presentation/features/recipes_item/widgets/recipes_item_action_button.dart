import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return MenuAnchor(
      builder: (_, controller, widget) => IconButton(
        icon: const Icon(MdiIcons.dotsVertical),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        if (isOwner || isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(MdiIcons.pencil),
            onPressed: edit,
            child: Text(context.l10n.recipes_item_action_button__edit),
          ),
        if (isOwner || isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(MdiIcons.trashCan),
            onPressed: delete,
            child: Text(context.l10n.recipes_item_action_button__delete),
          ),
        if (isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(MdiIcons.refresh),
            onPressed: transfer,
            child: Text(context.l10n.recipes_item_action_button__transfer),
          ),
      ],
    );
  }
}
