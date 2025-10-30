import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flutter/material.dart';

part 'recipe_ingredient_group_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeIngredientGroupDto with RecipeIngredientGroupDtoMappable {
  final String id;
  final int index;
  final List<RecipeIngredientGroupItemDto> ingredients;
  final String? label;

  const RecipeIngredientGroupDto({
    required this.id,
    required this.index,
    required this.ingredients,
    required this.label,
  });
}

@immutable
@MappableClass()
class RecipeIngredientGroupItemDto with RecipeIngredientGroupItemDtoMappable {
  final String id;
  final String label;
  final int index;
  final double? amount;
  final UnitLocalizedDto? unit;
  final RecipeIngredientGroupItemNutritionDto? nutrition;

  const RecipeIngredientGroupItemDto({
    required this.id,
    required this.label,
    required this.index,
    required this.amount,
    required this.unit,
    required this.nutrition,
  });
}

@immutable
@MappableClass()
class RecipeIngredientGroupItemNutritionDto
    with RecipeIngredientGroupItemNutritionDtoMappable {
  final String id;
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

  const RecipeIngredientGroupItemNutritionDto({
    required this.id,
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
}
