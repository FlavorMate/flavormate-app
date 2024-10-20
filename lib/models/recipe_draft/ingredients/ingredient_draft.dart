import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';
import 'package:flavormate/models/recipe_draft/nutrition/nutrition_draft.dart';
import 'package:flavormate/models/unit.dart';

part 'ingredient_draft.mapper.dart';

@MappableClass()
class IngredientDraft with IngredientDraftMappable {
  double amount;
  Unit? unit;
  String label;
  UnitLocalized? unitLocalized;
  NutritionDraft? nutrition;

  IngredientDraft({
    required this.amount,
    required this.label,
    this.unit,
    this.nutrition,
    this.unitLocalized,
  });

  bool get isValid => amount != 0 && label.isNotEmpty;

  String get beautify {
    final parts = [];

    if (amount > 0) parts.add(amount.beautify);
    if (unit != null) parts.add(unit!.beautify);
    parts.add(label);

    return parts.join(' ');
  }
}
