import 'package:collection/collection.dart';
import 'package:flavormate/components/dialogs/t_full_dialog.dart';
import 'package:flavormate/components/recipe_editor/dialogs/d_ingredient_group.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class DIngredientGroups extends StatefulWidget {
  final List<IngredientGroupDraft> ingredientGroups;

  const DIngredientGroups({
    super.key,
    required this.ingredientGroups,
  });

  @override
  State<StatefulWidget> createState() => _DIngredientGroupsState();
}

class _DIngredientGroupsState extends State<DIngredientGroups> {
  late List<IngredientGroupDraft> _ingredientGroups;

  @override
  void initState() {
    _ingredientGroups =
        widget.ingredientGroups.map((iG) => iG.copyWith()).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TFullDialog(
      title: L10n.of(context).d_editor_ingredient_groups_title,
      submit: () => submit(context),
      child: TColumn(
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label:
                      Text(L10n.of(context).d_editor_ingredient_groups_label),
                ),
                DataColumn(label: Container()),
              ],
              rows: _ingredientGroups
                  .mapIndexed(
                    (index, iG) => DataRow(
                      onSelectChanged: (_) => openGroup(iG),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              (iG.label?.isEmpty ?? true)
                                  ? L10n.of(context)
                                      .d_editor_ingredient_groups_label_2(
                                      '${index + 1}',
                                    )
                                  : iG.label!,
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: IconButton(
                              onPressed: () => deleteGroup(iG),
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
            onPressed: createGroup,
            child:
                Text(L10n.of(context).d_editor_ingredient_groups_create_group),
          )
        ],
      ),
    );
  }

  void openGroup(IngredientGroupDraft group) async {
    final response = await showDialog<IngredientGroupDraft>(
      context: context,
      builder: (_) => DIngredientGroup(ingredientGroup: group.copyWith()),
      useSafeArea: false,
    );

    if (response == null) return;

    final index = _ingredientGroups.indexOf(group);
    setState(() {
      _ingredientGroups[index] = response;
    });
  }

  void createGroup() {
    final ingredientGroup = IngredientGroupDraft(ingredients: []);

    setState(() => _ingredientGroups.add(ingredientGroup));

    openGroup(ingredientGroup);
  }

  void deleteGroup(IngredientGroupDraft group) {
    setState(() {
      _ingredientGroups.remove(group);
    });
  }

  void submit(BuildContext context) {
    context.pop(_ingredientGroups);
  }
}
