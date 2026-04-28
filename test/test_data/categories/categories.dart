import 'dart:ui';

import 'package:flavormate/data/models/features/categories/category_dto.dart';

import '../recipe_files/recipe_files.dart';

class Categories {
  static final Map<Locale, CategoryDto> cAutumn = {
    const Locale('en'): const CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0f',
      label: 'Autumn',
      recipeCount: 10,
      cover: null,
    ),
    const Locale('de'): const CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0f',
      label: 'Herbst',
      recipeCount: 10,
      cover: null,
    ),
  };

  static final Map<Locale, CategoryDto> cCake = {
    const Locale('en'): const CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0g',
      label: 'Cake',
      recipeCount: 27,
      cover: RecipeFiles.rfRocherCake,
    ),
    const Locale('de'): const CategoryDto(
      id: 'eff3dc43-236f-4e21-b8d1-1341996cbc0g',
      label: 'Kuchen',
      recipeCount: 27,
      cover: RecipeFiles.rfRocherCake,
    ),
  };
}
