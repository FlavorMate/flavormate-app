import 'dart:ui';

import 'package:flavormate/data/models/features/categories/category_dto.dart';

class Categories {
  static final Map<Locale, CategoryDto> c_autumn = {
    const Locale('en'): CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0f',
      label: 'Autumn',
      recipeCount: 10,
      cover: null,
    ),
    const Locale('de'): CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0f',
      label: 'Herbst',
      recipeCount: 10,
      cover: null,
    ),
  };
}
