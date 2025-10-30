import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_ingredient_group_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient.dart';

part 'common_ingredient_group.mapper.dart';

@MappableClass()
class CommonIngredientGroup with CommonIngredientGroupMappable {
  final String id;
  final String? label;
  final int index;
  final List<CommonIngredient> ingredients;

  const CommonIngredientGroup({
    required this.id,
    required this.label,
    required this.index,
    required this.ingredients,
  });

  factory CommonIngredientGroup.fromDraft(RecipeDraftIngredientGroupDto draft) {
    return CommonIngredientGroup(
      id: draft.id,
      label: draft.label,
      index: draft.index,
      ingredients: draft.ingredients.map(CommonIngredient.fromDraft).toList(),
    );
  }

  factory CommonIngredientGroup.fromRecipe(RecipeIngredientGroupDto recipe) {
    return CommonIngredientGroup(
      id: recipe.id,
      label: recipe.label,
      index: recipe.index,
      ingredients: recipe.ingredients.map(CommonIngredient.fromRecipe).toList(),
    );
  }
}
