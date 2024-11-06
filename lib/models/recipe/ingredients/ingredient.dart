import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/recipe/nutrition/nutrition.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_localized.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';
import 'package:flavormate/models/unit.dart';
import 'package:flavormate/utils/u_double.dart';

part 'ingredient.mapper.dart';

@MappableClass()
class Ingredient with IngredientMappable {
  final double? amount;
  final String label;
  final Unit? unit;
  final UnitLocalized? unitLocalized;
  final Nutrition? nutrition;

  Ingredient({
    required this.amount,
    required this.label,
    required this.unit,
    required this.unitLocalized,
    required this.nutrition,
  });

  @override
  String toString() {
    final amountLabel = amount?.beautify;
    String? unitLabel;

    if (unit != null) {
      unitLabel = unit!.label;
    } else if (unitLocalized != null) {
      unitLabel = unitLocalized!.getLabel(amount);
    }

    return [amountLabel, unitLabel, label].where(EString.isNotEmpty).join(' ');
  }

  String? unitLabel(double factor) {
    if (unit != null) {
      return unit!.label;
    } else if (unitLocalized != null) {
      return unitLocalized!.getLabel(UDouble.multiply(amount, factor));
    }
    return null;
  }

  IngredientDraft toDraft() {
    return IngredientDraft(
      amount: amount,
      label: label,
      unit: unit,
      unitLocalized: unitLocalized,
      nutrition: nutrition?.toDraft(),
    );
  }
}
