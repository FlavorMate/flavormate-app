import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_ingredient_group_dto.dart';

part 'common_nutrition.mapper.dart';

@MappableClass()
class CommonNutrition with CommonNutritionMappable {
  final String? openFoodFactsId;
  final double? carbohydrates;
  final double? energyKcal;
  final double? fat;
  final double? saturatedFat;
  final double? sugars;
  final double? fiber;
  final double? proteins;
  final double? salt;
  final double? sodium;

  const CommonNutrition({
    required this.openFoodFactsId,
    required this.carbohydrates,
    required this.energyKcal,
    required this.fat,
    required this.saturatedFat,
    required this.sugars,
    required this.fiber,
    required this.proteins,
    required this.salt,
    required this.sodium,
  });

  factory CommonNutrition.fromDraft(
    RecipeDraftIngredientGroupItemNutritionDto draft,
  ) {
    return CommonNutrition(
      openFoodFactsId: draft.openFoodFactsId,
      carbohydrates: draft.carbohydrates,
      energyKcal: draft.energyKcal,
      fat: draft.fat,
      saturatedFat: draft.saturatedFat,
      sugars: draft.sugars,
      fiber: draft.fiber,
      proteins: draft.proteins,
      salt: draft.salt,
      sodium: draft.sodium,
    );
  }

  factory CommonNutrition.fromRecipe(
    RecipeIngredientGroupItemNutritionDto recipe,
  ) {
    return CommonNutrition(
      openFoodFactsId: recipe.openFoodFactsId,
      carbohydrates: recipe.carbohydrates,
      energyKcal: recipe.energyKcal,
      fat: recipe.fat,
      saturatedFat: recipe.saturatedFat,
      sugars: recipe.sugars,
      fiber: recipe.fiber,
      proteins: recipe.proteins,
      salt: recipe.salt,
      sodium: recipe.sodium,
    );
  }

  factory CommonNutrition.empty() {
    return const CommonNutrition(
      openFoodFactsId: null,
      carbohydrates: null,
      energyKcal: null,
      fat: null,
      saturatedFat: null,
      sugars: null,
      fiber: null,
      proteins: null,
      salt: null,
      sodium: null,
    );
  }

  double get sum =>
      0.0 +
      (carbohydrates ?? sugars ?? 0) +
      (fat ?? saturatedFat ?? 0) +
      (fiber ?? 0) +
      (proteins ?? 0) +
      (salt ?? 0) +
      (sodium ?? 0);

  double get carbohydratesPercent => 100 / sum * (carbohydrates ?? sugars ?? 0);

  double get sugarsPercent => 100 / sum * (sugars ?? 0);

  double get fatPercent => 100 / sum * (fat ?? saturatedFat ?? 0);

  double get saturatedFatPercent => 100 / sum * (saturatedFat ?? 0);

  double get fiberPercent => 100 / sum * (fiber ?? 0);

  double get proteinsPercent => 100 / sum * (proteins ?? 0);

  double get saltPercent => 100 / sum * (salt ?? 0);

  double get sodiumPercent => 100 / sum * (sodium ?? 0);

  CommonNutrition add(CommonNutrition other) {
    return CommonNutrition(
      openFoodFactsId: null,
      carbohydrates: UDouble.add(carbohydrates, other.carbohydrates),
      energyKcal: UDouble.add(energyKcal, other.energyKcal),
      fat: UDouble.add(fat, other.fat),
      saturatedFat: UDouble.add(saturatedFat, other.saturatedFat),
      sugars: UDouble.add(sugars, other.sugars),
      fiber: UDouble.add(fiber, other.fiber),
      proteins: UDouble.add(proteins, other.proteins),
      salt: UDouble.add(salt, other.salt),
      sodium: UDouble.add(sodium, other.sodium),
    );
  }

  CommonNutrition multiply(double d) {
    return CommonNutrition(
      openFoodFactsId: openFoodFactsId,
      carbohydrates: UDouble.multiply(carbohydrates, d),
      energyKcal: UDouble.multiply(energyKcal, d),
      fat: UDouble.multiply(fat, d),
      saturatedFat: UDouble.multiply(saturatedFat, d),
      sugars: UDouble.multiply(sugars, d),
      fiber: UDouble.multiply(fiber, d),
      proteins: UDouble.multiply(proteins, d),
      salt: UDouble.multiply(salt, d),
      sodium: UDouble.multiply(sodium, d),
    );
  }

  bool get exists {
    return UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(energyKcal) ||
        UDouble.isPositive(fat) ||
        UDouble.isPositive(saturatedFat) ||
        UDouble.isPositive(sugars) ||
        UDouble.isPositive(fiber) ||
        UDouble.isPositive(proteins) ||
        UDouble.isPositive(salt) ||
        UDouble.isPositive(sodium);
  }

  bool get showChart {
    return UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(fat) ||
        UDouble.isPositive(saturatedFat) ||
        UDouble.isPositive(sugars) ||
        UDouble.isPositive(fiber) ||
        UDouble.isPositive(proteins) ||
        UDouble.isPositive(salt) ||
        UDouble.isPositive(sodium);
  }
}
