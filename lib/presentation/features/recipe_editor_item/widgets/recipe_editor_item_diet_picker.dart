import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemDietPicker extends StatelessWidget {
  final Diet? diet;

  const RecipeEditorItemDietPicker({super.key, required this.diet});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.recipe_editor_item_diet_picker__title),
      scrollable: true,
      constraints: const BoxConstraints(
        minWidth: 560,
        maxWidth: 560,
      ),
      insetPadding: const .all(PADDING),
      content: FTileGroup(
        iconBackgroundColor: Colors.transparent,
        items: List.generate(Diet.values.length, (index) {
          final item = Diet.values[index];
          return FTile(
            label: item.getName(context),
            subLabel: null,
            icon: diet == item
                ? MdiIcons.checkCircleOutline
                : MdiIcons.circleOutline,
            onTap: () => context.pop(item),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.l10n.btn_close),
        ),
      ],
    );
  }
}
