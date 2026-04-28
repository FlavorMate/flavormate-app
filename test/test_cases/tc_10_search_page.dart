import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/repositories/features/search/p_search.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar_value.dart';
import 'package:flavormate/presentation/features/search/search_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/categories/categories.dart';
import '../test_data/recipes/recipes.dart';
import '../test_data/tags/tags.dart';
import '../utils/u_pageable.dart';
import 'tc.dart';

class TC10SearchPage extends TC {
  const TC10SearchPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    final recipe1 = RecipePreviews.rLemonCake[locale]!;
    final recipe2 = RecipePreviews.rChocolateCake[locale]!;

    final category = Categories.cCake[locale]!;

    final tag = Tags.tCake[locale]!;

    final input = [
      SearchDto(recipe1.id, .Recipe, recipe1.label, recipe1.cover?.path),
      SearchDto(recipe2.id, .Recipe, recipe2.label, recipe2.cover?.path),
      SearchDto(category.id, .Category, category.label, category.cover?.path),
      SearchDto(tag.id, .Tag, tag.label, tag.cover?.path),
    ].sorted((a, b) => a.label.length.compareTo(b.label.length));

    final term = switch (locale) {
      const Locale('en') => 'cake',
      const Locale('de') => 'kuchen',
      _ => throw Exception(
        'Missing localization for search term in language ${locale.languageCode}',
      ),
    };

    return [
      pSearchBarValueProvider.overrideWithValue(term),
      pSearchProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(input),
      ),
      pSettingsImageModeProvider.overrideWithValue(.Scale),
      pCachedImageProvider.overrideWithBuild(
        (ref, it) => CacheImageProvider(
          url: it.url,
          imageLoader: (url) async {
            final asset = await assets.load(url.split('?')[0]);
            return asset.buffer.asUint8List();
          },
        ),
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '10_search_page',
      const SearchPage(),
    );
  }
}
