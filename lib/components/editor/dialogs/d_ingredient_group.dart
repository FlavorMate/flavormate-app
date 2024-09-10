import 'package:collection/collection.dart';
import 'package:flavormate/components/editor/dialogs/d_ingredient.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_full_dialog.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
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
              border: OutlineInputBorder(),
              label: Text(L10n.of(context).d_editor_ingredient_group_label),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: Text(
                    L10n.of(context).d_editor_ingredient_group_ingredient,
                  ),
                ),
                const DataColumn(label: Text('')),
              ],
              rows: _ingredientGroup.ingredients
                  .mapIndexed(
                    (index, iG) => DataRow(
                      onSelectChanged: (_) => openIngredient(iG),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: double.infinity,
                            child:
                                Text(iG.beautify.isEmpty ? '-' : iG.beautify),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: IconButton(
                              onPressed: () => deleteIngredient(iG),
                              icon: Icon(
                                MdiIcons.delete,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
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
      builder: (_) => DIngredient(ingredient: ingredient.copyWith()),
    );

    if (response == null) return;

    final index = _ingredientGroup.ingredients.indexOf(ingredient);
    setState(() {
      _ingredientGroup.ingredients[index] = response;
    });
  }

  void createIngredient() {
    setState(() {
      _ingredientGroup.ingredients.add(
        IngredientDraft(
          amount: 0,
          unit: null,
          label: '',
        ),
      );
    });
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
