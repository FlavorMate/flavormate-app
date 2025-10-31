import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorItemDietPicker extends StatelessWidget {
  final Diet? diet;

  const RecipeEditorItemDietPicker({super.key, required this.diet});

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: L10n.of(context).recipe_editor_item_diet_picker__title,
      child: Column(
        spacing: PADDING,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final diet in Diet.values)
            FButton(
              onPressed: () => context.pop(diet),
              leading: Icon(diet.icon),
              label: diet.getName(context),
              trailing: this.diet == diet
                  ? const Icon(MdiIcons.checkCircleOutline)
                  : null,
            ),
        ],
      ),
    );
  }
}
