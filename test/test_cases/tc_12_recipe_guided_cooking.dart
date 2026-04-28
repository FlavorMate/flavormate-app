import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/config/features/p_feature_ratings.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/data/models/extensions/ratings/recipe_rating_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/repositories/extension/ratings/p_rest_ratings_id.dart';
import 'package:flavormate/presentation/features/recipes_item/models/p_recipe_wrapper.dart';
import 'package:flavormate/presentation/features/recipes_item/providers/p_recipes_item_page.dart';
import 'package:flavormate/presentation/features/recipes_item/recipes_item_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/recipes/recipes.dart';
import 'tc.dart';

class TC12RecipeGuidedCooking extends TC {
  const TC12RecipeGuidedCooking({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides => [
    pRecipesItemPageProvider.overrideWithBuild(
      (ref, it) => PRecipePageWrapper(
        recipe: CommonRecipe.fromRecipe(
          RecipeFulls.rAppleCake[locale]!(),
        ),
        isBringEnabled: false,
        isShareEnabled: true,
        isOwner: true,
        isAdmin: true,
      ),
    ),
    pFeatureRatingsProvider.overrideWithValue(true),
    pSettingsImageModeProvider.overrideWithValue(.Scale),
    pRestRatingsIdProvider.overrideWithBuild(
      (ref, it) => const RecipeRatingDto('id', 0, 0, 2, 6, 14, 22, 4.54, 5),
    ),
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

  @override
  void run() {
    final recipe = RecipeFulls.rAppleCake[locale]!();

    screenshot(
      '12_guided_cooking',
      RecipesItemPage(id: recipe.id),
      beforeScreenshot: (tester) async {
        final btn = find.byKey(const ValueKey('guided-cooking-btn'));

        await tester.tap(btn);

        await tester.pump(const Duration(seconds: 1));
      },
    );
  }
}
