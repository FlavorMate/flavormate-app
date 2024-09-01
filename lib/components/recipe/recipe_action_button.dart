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
            case _ActionButtonValues.transfer:
              transfer();
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
          if (user.isOwner)
            PopupMenuItem(
              value: _ActionButtonValues.delete,
              child: ListTile(
                title: Text(L10n.of(context).p_recipe_actions_delete),
                leading: const Icon(MdiIcons.trashCan),
              ),
            ),
          if (user.isAdmin)
            PopupMenuItem(
              value: _ActionButtonValues.transfer,
              child: ListTile(
                title: Text(L10n.of(context).p_recipe_actions_transfer),
                leading: const Icon(MdiIcons.refresh),
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
  transfer;
}
