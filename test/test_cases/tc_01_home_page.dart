import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/presentation/features/home/home_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/accounts/accounts.dart';
import '../test_data/highlights/highlights.dart';
import '../test_data/recipes/recipes.dart';
import '../test_data/stories/stories.dart';
import '../test_widgets/main_test_layout.dart';
import '../utils/u_pageable.dart';
import 'tc.dart';

class TC01HomePage extends TC {
  const TC01HomePage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    final newestRecipes = RecipePreviews.getByOrder(
      locale,
      (a, b) => b.createdOn.compareTo(a.createdOn),
    );

    final account = AccountFulls.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc;

    final highlights = Highlights.getByOrder(
      locale,
      (a, b) => b.date.compareTo(a.date),
    );

    final stories = [Stories.s_b5b26f00_2f79_4eb8_9978_e86d29300dec[locale]!];

    return [
      pFeatureStoryProvider.overrideWithValue(true),
      pRestAccountsSelfProvider.overrideWithBuild(
        (ref, it) => account,
      ),
      pRestStoriesProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(stories),
      ),
      pRestHighlightsProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(highlights),
      ),
      pRestRecipesProvider.overrideWithBuild(
        (ref, it) => UPageableDto.fromTestData(newestRecipes),
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
      '1_home',
      const MainTestLayout(
        activeIndex: 0,
        child: HomePage(),
      ),
    );
  }
}
