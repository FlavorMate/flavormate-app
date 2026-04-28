import 'dart:ui';

import 'package:flavormate/data/models/features/tags/tag_dto.dart';

class Tags {
  static final Map<Locale, TagDto> t_cake = {
    const Locale('en'): const TagDto(
      id: '9631ab97-fa22-4d03-889c-9492e3c408bd',
      label: 'cake',
      recipeCount: 7,
      cover: null,
    ),
    const Locale('de'): const TagDto(
      id: '9631ab97-fa22-4d03-889c-9492e3c408bd',
      label: 'kuchen',
      recipeCount: 7,
      cover: null,
    ),
  };

  static final Map<Locale, TagDto> t_heavy_cream = {
    const Locale('en'): const TagDto(
      id: '3664572e-1e64-45eb-be70-f3aaee64f0cd',
      label: 'heavy-cream',
      recipeCount: 2,
      cover: null,
    ),
    const Locale('de'): const TagDto(
      id: '3664572e-1e64-45eb-be70-f3aaee64f0cd',
      label: 'sahne',
      recipeCount: 2,
      cover: null,
    ),
  };

  static final Map<Locale, TagDto> t_apple = {
    const Locale('en'): const TagDto(
      id: 'a3ff62c9-6350-46ac-9834-3df45267eb76',
      label: 'apple',
      recipeCount: 3,
      cover: null,
    ),
    const Locale('de'): const TagDto(
      id: 'a3ff62c9-6350-46ac-9834-3df45267eb76',
      label: 'apfel',
      recipeCount: 3,
      cover: null,
    ),
  };
}
