import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item/providers/p_recipe_editor_item_ingredient_groups_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_ingredient_groups_item_ingredient.g.dart';

@riverpod
class PRecipeEditorItemIngredientGroupsItemIngredient
    extends _$PRecipeEditorItemIngredientGroupsItemIngredient {
  PRecipeEditorItemIngredientGroupsItemProvider get _parentProvider =>
      pRecipeEditorItemIngredientGroupsItemProvider(draftId, ingredientGroupId);

  Map<String, dynamic> get _baseForm => {'id': ingredientId};

  @override
  Future<RecipeDraftIngredientGroupItemDto> build(
    String draftId,
    String ingredientGroupId,
    String ingredientId,
  ) async {
    return await ref.watch(
      _parentProvider.selectAsync(
        (group) => group.ingredients
            .where((ingredient) => ingredient.id == ingredientId)
            .first,
      ),
    );
  }

  Future<void> setLabel(String label) async {
    final form = _baseForm;

    form['label'] = label.trimToNull;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> setAmount(String amount) async {
    final form = _baseForm;

    form['amount'] = UDouble.tryParsePositive(amount);

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> setUnit(String? id) async {
    final form = _baseForm;

    form['unit'] = id.trimToNull;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> setNutrition(
    RecipeDraftIngredientGroupItemNutritionDto nutrition,
  ) async {
    final form = _baseForm;

    form['nutrition'] = nutrition.toMap();

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> delete() async {
    final form = _baseForm;

    form['delete'] = true;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }
}
