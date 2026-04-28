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
      bBreakfast[locale]!,
      bFavorites[locale]!,
    ].sorted(compare);
  }

  static final Map<Locale, BookDto> bBreakfast = {
    const Locale('en'): BookDto(
      id: 'e075c666-4167-4564-97dd-60615eca0c62',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.aThenus,
      label: 'Breakfast',
      visible: false,
      cover: RecipeFiles.rfOvernightOats,
      recipeCount: 3,
      subscriberCount: 1,
    ),
    const Locale('de'): BookDto(
      id: 'e075c666-4167-4564-97dd-60615eca0c62',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.aThenus,
      label: 'Frühstück',
      visible: false,
      cover: RecipeFiles.rfOvernightOats,
      recipeCount: 3,
      subscriberCount: 1,
    ),
  };

  static final Map<Locale, BookDto> bFavorites = {
    const Locale('en'): BookDto(
      id: 'fe229d54-dfd5-44fa-8a70-64799ec4d933',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.aThenus,
      label: 'Favorites',
      visible: false,
      cover: RecipeFiles.rfNutBars,
      recipeCount: 3,
      subscriberCount: 1,
    ),
    const Locale('de'): BookDto(
      id: 'fe229d54-dfd5-44fa-8a70-64799ec4d933',
      version: 1,
      createdOn: DateTime(2025, 12, 03, 20, 29, 44),
      lastModifiedOn: DateTime(2025, 12, 03, 20, 29, 44),
      ownedBy: AccountPreviews.aThenus,
      label: 'Favoriten',
      visible: true,
      cover: RecipeFiles.rfNutBars,
      recipeCount: 8,
      subscriberCount: 1,
    ),
  };
}
