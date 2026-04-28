import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flutter/material.dart';

class Units {
  static final Map<Locale, UnitLocalizedDto> uMilliliter = {
    const Locale('en'): const UnitLocalizedDto(
      id: '12111ef2-b303-4a72-a4a3-f9cafbf02225',
      unitRef: UnitRefDto(
        id: '1adbb935-c116-4712-97c9-cb830c95ee33',
        description: 'milliliter',
      ),
      labelSg: 'Milliliter',
      labelSgAbrv: 'ml',
      labelPl: null,
      labelPlAbrv: null,
    ),
    const Locale('de'): const UnitLocalizedDto(
      id: '12111ef2-b303-4a72-a4a3-f9cafbf02225',
      unitRef: UnitRefDto(
        id: '1adbb935-c116-4712-97c9-cb830c95ee33',
        description: 'milliliter',
      ),
      labelSg: 'Milliliter',
      labelSgAbrv: 'ml',
      labelPl: null,
      labelPlAbrv: null,
    ),
  };

  static final Map<Locale, UnitLocalizedDto> uTeaspoon = {
    const Locale('en'): const UnitLocalizedDto(
      id: '0b573ec1-b725-470f-a97a-b3eca1bd3d1f',
      unitRef: UnitRefDto(
        id: '5804c120-43c5-4627-a808-01a6cb5ebbeb',
        description: 'teaspoon',
      ),
      labelSg: 'teaspoon',
      labelSgAbrv: 'tsp',
      labelPl: null,
      labelPlAbrv: null,
    ),
    const Locale('de'): const UnitLocalizedDto(
      id: '0b573ec1-b725-470f-a97a-b3eca1bd3d1f',
      unitRef: UnitRefDto(
        id: '5804c120-43c5-4627-a808-01a6cb5ebbeb',
        description: 'teaspoon',
      ),
      labelSg: 'Teelöffel',
      labelSgAbrv: 'TL',
      labelPl: null,
      labelPlAbrv: null,
    ),
  };

  static final Map<Locale, UnitLocalizedDto> uGram = {
    const Locale('en'): const UnitLocalizedDto(
      id: '139fd5d3-4f08-4b10-96cf-6d619555a3bd',
      unitRef: UnitRefDto(
        id: 'a736bf0e-e8a4-4605-a173-c710bfa0a4e4',
        description: 'gram',
      ),
      labelSg: 'gram',
      labelSgAbrv: 'gr',
      labelPl: 'grams',
      labelPlAbrv: null,
    ),
    const Locale('de'): const UnitLocalizedDto(
      id: '139fd5d3-4f08-4b10-96cf-6d619555a3bd',
      unitRef: UnitRefDto(
        id: 'a736bf0e-e8a4-4605-a173-c710bfa0a4e4',
        description: 'gram',
      ),
      labelSg: 'Gramm',
      labelSgAbrv: 'g',
      labelPl: null,
      labelPlAbrv: null,
    ),
  };
}
