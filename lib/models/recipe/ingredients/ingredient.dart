import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/unit.dart';

part 'ingredient.mapper.dart';

@MappableClass()
class Ingredient with IngredientMappable {
  final double amount;
  final String label;
  final Unit? unit;
  final Nutrition? nutrition;

  Ingredient({
    required this.amount,
    required this.label,
    required this.unit,
    required this.nutrition,
  });

  IngredientDraft toDraft() {
    return IngredientDraft(
      amount: amount,
      label: label,
      unit: unit,
      nutrition: nutrition?.toDraft(),
    );
  }
}
