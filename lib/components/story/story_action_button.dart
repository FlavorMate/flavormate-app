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
      (_, user) => PopupMenuButton<_ActionButtonValues>(
        icon: const Icon(Icons.more_vert),
        onSelected: (item) {
          switch (item) {
            case _ActionButtonValues.edit:
              edit();
              return;
            case _ActionButtonValues.delete:
              delete();
              return;
          }
        },
        itemBuilder: (_) => [
          if (user.isOwner)
            PopupMenuItem(
              value: _ActionButtonValues.edit,
              child: ListTile(
                title: Text(L10n.of(context).p_recipe_actions_edit),
                leading: const Icon(MdiIcons.pencil),
              ),
            ),
          if (user.isOwner || user.isAdmin)
            PopupMenuItem(
              value: _ActionButtonValues.delete,
              child: ListTile(
                title: Text(L10n.of(context).p_recipe_actions_delete),
                leading: const Icon(MdiIcons.trashCan),
              ),
            ),
        ],
      ),
    );
  }
}

enum _ActionButtonValues {
  edit,
  delete,
}
