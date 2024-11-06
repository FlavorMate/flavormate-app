import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/utils/u_double.dart';

part 'nutrition_draft.mapper.dart';

@MappableClass()
class NutritionDraft with NutritionDraftMappable {
  final String? openFoodFactsId;

  // Nutritional values per 100g
  final double? carbohydrates;
  final double? energyKcal;
  final double? fat;
  final double? saturatedFat;
  final double? sugars;
  final double? fiber;
  final double? proteins;
  final double? salt;
  final double? sodium;

  NutritionDraft({
    this.openFoodFactsId,
    this.carbohydrates,
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.sugars,
    this.fiber,
    this.proteins,
    this.salt,
    this.sodium,
  });

  bool get exists {
    return EString.isNotEmpty(openFoodFactsId) ||
        UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(carbohydrates) ||
        UDouble.isPositive(energyKcal) ||
        UDouble.isPositive(fat) ||
        UDouble.isPositive(saturatedFat) ||
        UDouble.isPositive(sugars) ||
        UDouble.isPositive(fiber) ||
        UDouble.isPositive(proteins) ||
        UDouble.isPositive(salt) ||
        UDouble.isPositive(sodium);
  }
}
