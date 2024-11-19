import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/recipe_editor/dialogs/d_ingredient.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_data_table.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DIngredientGroup extends StatefulWidget {
  final IngredientGroupDraft ingredientGroup;

  const DIngredientGroup({
    super.key,
    required this.ingredientGroup,
  });

  @override
  State<StatefulWidget> createState() => _DIngredientGroupState();
}

class _DIngredientGroupState extends State<DIngredientGroup> {
  final _labelController = TextEditingController();

  late IngredientGroupDraft _ingredientGroup;

  @override
  void initState() {
    _ingredientGroup = widget.ingredientGroup.copyWith();
    _labelController.text = _ingredientGroup.label ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_ingredient_group_title,
      submit: () => submit(context),
      child: TColumn(
        children: [
          TextField(
            controller: _labelController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(L10n.of(context).d_editor_ingredient_group_label),
            ),
          ),
          TDataTable(
            columns: [
              TDataColumn(
                alignment: Alignment.centerLeft,
                child: Text(
                  L10n.of(context).d_editor_ingredient_group_ingredient,
                ),
              ),
              TDataColumn(
                child: Text(L10n.of(context).d_nutrition_title),
                width: 128,
              ),
              TDataColumn(width: TABLE_ICON_WIDTH),
            ],
            rows: [
              for (final ingredient in _ingredientGroup.ingredients)
                TDataRow(
                  onSelectChanged: (_) => openIngredient(ingredient),
                  cells: [
                    Text(ingredient.beautify),
                    Visibility(
                      visible: ingredient.nutrition?.exists ?? false,
                      child: Icon(MdiIcons.checkCircleOutline),
                    ),
                    IconButton(
                      onPressed: () => deleteIngredient(ingredient),
                      icon: Icon(MdiIcons.delete),
                      color: Colors.red,
                    ),
                  ],
                ),
            ],
          ),
          FilledButton.tonal(
            onPressed: createIngredient,
            child: Text(
              L10n.of(context).d_editor_ingredient_group_add_ingredient,
            ),
          )
        ],
      ),
    );
  }

  void openIngredient(IngredientDraft ingredient) async {
    final response = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DIngredient(ingredient: ingredient.copyWith()),
    );

    if (response == null) return;

    final index = _ingredientGroup.ingredients.indexOf(ingredient);
    setState(() {
      _ingredientGroup.ingredients[index] = response;
    });
  }

  void createIngredient() {
    final ingredient = IngredientDraft(label: '');

    setState(() => _ingredientGroup.ingredients.add(ingredient));

    openIngredient(ingredient);
  }

  void deleteIngredient(IngredientDraft group) {
    setState(() {
      _ingredientGroup.ingredients.remove(group);
    });
  }

  void submit(BuildContext context) {
    _ingredientGroup.label = EString.trimToNull(_labelController.text);
    context.pop(_ingredientGroup);
  }
}
