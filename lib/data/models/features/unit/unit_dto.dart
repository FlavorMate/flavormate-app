import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flutter/material.dart';

part 'unit_dto.mapper.dart';

@immutable
@MappableClass()
class UnitRefDto with UnitRefDtoMappable {
  final String id;
  final String description;

  const UnitRefDto({required this.id, required this.description});

  static final _convertable = [
    // fluids
    'teaspoon',
    'tablespoon',
    'smooth tablespoon',
    'heaped tablespoon',
    'level teaspoon',
    'heaped teaspoon',
    'cup',
    'pint',
    'quart',
    'gallon',
    'centiliter',
    'deciliter',
    'milliliter',
    'liter',
    // weights
    'ounce',
    'pound',
    'gram',
    'kilogram',
    'milligram',
  ];

  bool get isConvertable => _convertable.contains(description);
}

@immutable
@MappableClass()
class UnitLocalizedDto with UnitLocalizedDtoMappable {
  final String id;
  final UnitRefDto unitRef;
  final String labelSg;
  final String? labelSgAbrv;
  final String? labelPl;
  final String? labelPlAbrv;

  const UnitLocalizedDto({
    required this.id,
    required this.unitRef,
    required this.labelSg,
    required this.labelSgAbrv,
    required this.labelPl,
    required this.labelPlAbrv,
  });

  String? getLabel(double? amount) {
    if (amount != 1.0) {
      if (labelPlAbrv.isNotBlank) {
        return labelPlAbrv;
      } else if (labelPl.isNotBlank) {
        return labelPl;
      }
    }

    return labelSgAbrv.isNotBlank ? labelSgAbrv : labelSg;
  }
}
