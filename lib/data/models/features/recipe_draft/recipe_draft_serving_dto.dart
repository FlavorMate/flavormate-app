import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flutter/material.dart';

part 'recipe_draft_serving_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeDraftServingDto with RecipeDraftServingDtoMappable {
  final String id;
  final double? amount;
  final String? label;

  const RecipeDraftServingDto({
    required this.id,
    required this.amount,
    required this.label,
  });

  bool get isValid => UDouble.isPositive(amount) && EString.isNotEmpty(label);

  double get validPercent {
    double state = 0;

    if (UDouble.isPositive(amount)) state += 0.5;
    if (EString.isNotEmpty(label)) state += 0.5;

    return state;
  }
}
