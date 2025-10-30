import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

class RecipeEditorFab extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onScrape;

  const RecipeEditorFab({
    super.key,
    required this.onCreate,
    required this.onScrape,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        heroTag: UniqueKey(),
        child: const Icon(MdiIcons.plus),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        heroTag: UniqueKey(),
        backgroundColor: context.colorScheme.primaryContainer,
        foregroundColor: context.colorScheme.onPrimaryContainer,
        child: const Icon(MdiIcons.close),
      ),
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.black.withAlpha(100),
      ),
      children: [
        FloatingActionButton.extended(
          heroTag: UniqueKey(),
          label: Text(L10n.of(context).recipe_editor_fab__import_recipe),
          icon: const Icon(MdiIcons.download),
          onPressed: onScrape,
          shape: const StadiumBorder(),
        ),
        FloatingActionButton.extended(
          heroTag: UniqueKey(),
          label: Text(L10n.of(context).recipe_editor_fab__create_recipe),
          icon: const Icon(MdiIcons.pencil),
          onPressed: onCreate,
          shape: const StadiumBorder(),
        ),
      ],
    );
  }
}
