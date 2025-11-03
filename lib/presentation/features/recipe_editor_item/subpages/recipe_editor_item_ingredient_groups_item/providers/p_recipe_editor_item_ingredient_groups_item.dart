import 'package:collection/collection.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups/providers/p_recipe_editor_item_instruction_groups.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'p_recipe_editor_item_ingredient_groups_item.g.dart';

@riverpod
class PRecipeEditorItemIngredientGroupsItem
    extends _$PRecipeEditorItemIngredientGroupsItem {
  PRecipeEditorItemIngredientGroupsProvider get _parentProvider =>
      pRecipeEditorItemIngredientGroupsProvider(draftId);

  Map<String, dynamic> get _baseForm => {'id': ingredientGroupId};

  @override
  Future<RecipeDraftIngredientGroupDto> build(
    String draftId,
    String ingredientGroupId,
  ) async {
    return await ref.watch(
      _parentProvider.selectAsync(
        (groups) =>
            groups.where((group) => group.id == ingredientGroupId).first,
      ),
    );
  }

  Future<void> createIngredient() async {
    final id = const Uuid().v4();
    final index = state.value!.ingredients.length;

    final form = _baseForm;

    form['ingredients'] = [
      {'id': id, 'index': index},
    ];

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> delete() async {
    final form = _baseForm;

    form['delete'] = true;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> setLabel(String label) async {
    final form = _baseForm;

    form['label'] = label.trimToNull;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final newOrder = state.value!.ingredients
        .sortedBy((it) => it.index)
        .swapItems(oldIndex, newIndex)
        .mapIndexed((index, item) => {'id': item.id, 'index': index})
        .toList();

    final form = _baseForm;

    form['ingredients'] = newOrder;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> updateChild(Map<String, dynamic> childForm) async {
    final form = _baseForm;

    form['ingredients'] = [childForm];

    await ref.read(_parentProvider.notifier).updateChild(form);
  }
}
