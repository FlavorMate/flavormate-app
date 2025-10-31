import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

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
    return MenuAnchor(
      builder: (_, controller, _) => IconButton(
        icon: const Icon(MdiIcons.dotsVertical),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        if (isOwner || isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(MdiIcons.pencil),
            onPressed: edit,
            child: Text(L10n.of(context).stories_item_action_button__edit),
          ),
        if (isOwner || isAdmin)
          MenuItemButton(
            leadingIcon: const Icon(MdiIcons.trashCan),
            onPressed: delete,
            child: Text(L10n.of(context).stories_item_action_button__delete),
          ),
      ],
    );
  }
}
