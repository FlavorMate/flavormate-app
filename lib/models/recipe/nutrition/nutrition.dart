import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe_draft/nutrition/nutrition_draft.dart';

part 'nutrition.mapper.dart';

@MappableClass()
class Nutrition extends Entity with NutritionMappable {
  final String openFoodFactsId;

  // Nutritional values per 100g
  final double carbohydrates;
  final double energyKcal;
  final double fat;
  final double saturatedFat;
  final double sugars;
  final double fiber;
  final double proteins;
  final double salt;
  final double sodium;

  Nutrition({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
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

  NutritionDraft toDraft() {
    return NutritionDraft(
      openFoodFactsId: openFoodFactsId,
      carbohydrates: carbohydrates,
      energyKcal: energyKcal,
      fat: fat,
      saturatedFat: saturatedFat,
      sugars: sugars,
      fiber: fiber,
      proteins: proteins,
      salt: salt,
      sodium: sodium,
    );
  }
}
