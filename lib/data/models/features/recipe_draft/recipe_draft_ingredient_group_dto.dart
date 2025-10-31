import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_number.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'recipe_draft_ingredient_group_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeDraftIngredientGroupDto with RecipeDraftIngredientGroupDtoMappable {
  final String id;
  final int index;
  final List<RecipeDraftIngredientGroupItemDto> ingredients;
  final String? label;

  const RecipeDraftIngredientGroupDto({
    required this.id,
    required this.index,
    required this.ingredients,
    required this.label,
  });

  factory RecipeDraftIngredientGroupDto.create({required int index}) {
    return RecipeDraftIngredientGroupDto(
      id: const Uuid().v4(),
      index: index,
      ingredients: const [],
      label: null,
    );
  }

  bool get isValid =>
      ingredients.isNotEmpty && ingredients.every((i) => i.isValid);

  double get validPercent {
    if (ingredients.isEmpty) return 0;

    return ingredients.where((ingredient) => ingredient.isValid).length /
        ingredients.length;
  }
}

@immutable
@MappableClass()
class RecipeDraftIngredientGroupItemDto
    with RecipeDraftIngredientGroupItemDtoMappable {
  final String id;
  final int index;
  final String? label;
  final double? amount;
  final UnitLocalizedDto? unit;
  final RecipeDraftIngredientGroupItemNutritionDto? nutrition;

  const RecipeDraftIngredientGroupItemDto({
    required this.id,
    required this.label,
    required this.index,
    required this.amount,
    required this.unit,
    required this.nutrition,
  });

  String get beautify {
    final parts = [];

    if (amount != null && amount! > 0) parts.add(amount!.beautify);
    if (unit != null) parts.add(unit!.getLabel(amount));
    if (label != null) parts.add(label);

    return parts.isEmpty ? '-' : parts.join(' ');
  }

  bool get isValid => label?.isNotEmpty ?? false;

  double get validPercent {
    double state = 0;

    if (amount != null && amount! > 0) state += 0.33;
    if (unit != null) state += 0.33;
    if (label != null) state += 1;

    return state;
  }

  factory RecipeDraftIngredientGroupItemDto.create({required int index}) {
    return RecipeDraftIngredientGroupItemDto(
      id: const Uuid().v4(),
      label: null,
      index: index,
      amount: null,
      unit: null,
      nutrition: null,
    );
  }
}

@immutable
@MappableClass()
class RecipeDraftIngredientGroupItemNutritionDto
    with RecipeDraftIngredientGroupItemNutritionDtoMappable {
  final String? openFoodFactsId;
  final double? carbohydrates;
  final double? energyKcal;
  final double? fat;
  final double? fiber;
  final double? proteins;
  final double? salt;
  final double? saturatedFat;
  final double? sodium;
  final double? sugars;

  const RecipeDraftIngredientGroupItemNutritionDto({
    required this.openFoodFactsId,
    required this.carbohydrates,
    required this.energyKcal,
    required this.fat,
    required this.fiber,
    required this.proteins,
    required this.salt,
    required this.saturatedFat,
    required this.sodium,
    required this.sugars,
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

  factory RecipeDraftIngredientGroupItemNutritionDto.create() {
    return const RecipeDraftIngredientGroupItemNutritionDto(
      openFoodFactsId: null,
      carbohydrates: null,
      energyKcal: null,
      fat: null,
      fiber: null,
      proteins: null,
      salt: null,
      saturatedFat: null,
      sodium: null,
      sugars: null,
    );
  }
}
