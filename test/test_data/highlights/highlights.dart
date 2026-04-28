import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/data/models/features/highlights/highlight_dto.dart';

import '../recipes/recipes.dart';

class Highlights {
  static List<HighlightDto> getByOrder(
    Locale locale,
    int Function(HighlightDto, HighlightDto) compare,
  ) {
    return [
      h_62c45e91_d60c_47fc_b3d0_b33c55290db1(locale),
      h_0296bc3d_d37c_4dec_8018_1f6dc0d67e12(locale),
      h_81e51141_30b5_41c3_8323_dad0ee17053c(locale),
      h_c8e4d21f_109b_4eb2_807d_476c12270779(locale),
      h_a0cd580a_5f9d_435c_b7c5_030fceafe119(locale),
    ].sorted(compare);
  }

  static HighlightDto h_62c45e91_d60c_47fc_b3d0_b33c55290db1(
    Locale locale,
  ) => HighlightDto(
    id: '62c45e91-d60c-47fc-b3d0-b33c55290db1',
    date: DateTime(2026, 04, 21),
    diet: .Meat,
    recipe: RecipePreviews.rGreekSalad[locale]!,
    cover: RecipePreviews.rGreekSalad[locale]!.cover,
  );

  static HighlightDto h_0296bc3d_d37c_4dec_8018_1f6dc0d67e12(
    Locale locale,
  ) => HighlightDto(
    id: '0296bc3d-d37c-4dec-8018-1f6dc0d67e12',
    date: DateTime(2026, 04, 23),
    diet: .Meat,
    recipe: RecipePreviews.rPizzaDough[locale]!,
    cover: RecipePreviews.rPizzaDough[locale]!.cover,
  );

  static HighlightDto h_81e51141_30b5_41c3_8323_dad0ee17053c(
    Locale locale,
  ) => HighlightDto(
    id: '81e51141-30b5-41c3-8323-dad0ee17053c',
    date: DateTime(2026, 04, 25),
    diet: .Meat,
    recipe: RecipePreviews.rNutBars[locale]!,
    cover: RecipePreviews.rNutBars[locale]!.cover,
  );

  static HighlightDto h_c8e4d21f_109b_4eb2_807d_476c12270779(
    Locale locale,
  ) => HighlightDto(
    id: 'c8e4d21f-109b-4eb2-807d-476c12270779',
    date: DateTime(2026, 04, 24),
    diet: .Meat,
    recipe: RecipePreviews.rLemonCake[locale]!,
    cover: RecipePreviews.rLemonCake[locale]!.cover,
  );

  static HighlightDto h_a0cd580a_5f9d_435c_b7c5_030fceafe119(
    Locale locale,
  ) => HighlightDto(
    id: 'a0cd580a-5f9d-435c-b7c5-030fceafe119',
    date: DateTime(2026, 04, 22),
    diet: .Meat,
    recipe: RecipePreviews.rGrandmasButterCookies[locale]!,
    cover: RecipePreviews.rGrandmasButterCookies[locale]!.cover,
  );
}
