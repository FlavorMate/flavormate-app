import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';

import '../accounts/accounts.dart';
import '../recipe_files/recipe_files.dart';

class Books {
  static List<BookDto> getByOrder(
    Locale locale,
    int Function(BookDto, BookDto) compare,
  ) {
    return [
      b_e075c666_4167_4564_97dd_60615eca0c62[locale]!,
      b_fe229d54_dfd5_44fa_8a70_64799ec4d933[locale]!,
    ].sorted(compare);
  }

  static final Map<Locale, BookDto> b_e075c666_4167_4564_97dd_60615eca0c62 = {
    const Locale('en'): BookDto(
      id: 'e075c666-4167-4564-97dd-60615eca0c62',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
      label: 'Breakfast',
      visible: false,
      cover: RecipeFiles.rf_25480138_78d2_421a_b8a0_2b1c8f7fc679,
      recipeCount: 3,
      subscriberCount: 1,
    ),
    const Locale('de'): BookDto(
      id: 'e075c666-4167-4564-97dd-60615eca0c62',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
      label: 'Frühstück',
      visible: false,
      cover: RecipeFiles.rf_25480138_78d2_421a_b8a0_2b1c8f7fc679,
      recipeCount: 3,
      subscriberCount: 1,
    ),
  };

  static final Map<Locale, BookDto> b_fe229d54_dfd5_44fa_8a70_64799ec4d933 = {
    const Locale('en'): BookDto(
      id: 'fe229d54-dfd5-44fa-8a70-64799ec4d933',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
      label: 'Favorites',
      visible: false,
      cover: RecipeFiles.rf_6e39c472_c41f_4dd2_b8f3_dcdbfe3c04a8,
      recipeCount: 3,
      subscriberCount: 1,
    ),
    const Locale('de'): BookDto(
      id: 'fe229d54-dfd5-44fa-8a70-64799ec4d933',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
      label: 'Favoriten',
      visible: true,
      cover: RecipeFiles.rf_6e39c472_c41f_4dd2_b8f3_dcdbfe3c04a8,
      recipeCount: 8,
      subscriberCount: 1,
    ),
  };
}
