import 'package:dart_mappable/dart_mappable.dart';

part 'nutrition_draft.mapper.dart';

@MappableClass()
class NutritionDraft with NutritionDraftMappable {
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

  NutritionDraft({
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
}
