import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_nutrition.dart';

part 'common_ingredient.mapper.dart';

@MappableClass()
class CommonIngredient with CommonIngredientMappable {
  final String id;
  final String label;
  final int index;
  final double? amount;
  final UnitLocalizedDto? unit;
  final CommonNutrition? nutrition;

  const CommonIngredient({
    required this.id,
    required this.label,
    required this.index,
    required this.amount,
    required this.unit,
    required this.nutrition,
  });

  factory CommonIngredient.fromDraft(RecipeDraftIngredientGroupItemDto draft) {
    return CommonIngredient(
      id: draft.id,
      index: draft.index,
      label: draft.label!,
      amount: draft.amount,
      unit: draft.unit,
      nutrition: draft.nutrition?.let(CommonNutrition.fromDraft),
    );
  }

  factory CommonIngredient.fromRecipe(RecipeIngredientGroupItemDto recipe) {
    return CommonIngredient(
      id: recipe.id,
      label: recipe.label,
      index: recipe.index,
      amount: recipe.amount,
      unit: recipe.unit,
      nutrition: recipe.nutrition?.let(CommonNutrition.fromRecipe),
    );
  }

  String getAmountLabel(double factor) {
    return [_getAmount(factor), _getUnitLabel(factor)].nonNulls.join(' ');
  }

  String? _getAmount(double factor) {
    if (amount == null || amount! <= 0) return null;

    return UDouble.multiply(amount, factor)?.beautify;
  }

  String? _getUnitLabel(double factor) {
    return unit?.getLabel(UDouble.multiply(amount, factor));
  }
}
