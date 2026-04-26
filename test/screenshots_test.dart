/// This file contains the tests that take screenshots of the app.
///
/// Run it with `flutter test --update-goldens` to generate the screenshots
/// or `flutter test` to compare the screenshots to the golden files.
library;

import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/config/features/p_feature_ratings.dart';
import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_custom_color.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_mode.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_tone.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/core/theme/providers/p_dynamic_color.dart';
import 'package:flavormate/data/models/extensions/ratings/recipe_rating_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_serving_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/repositories/extension/ratings/p_rest_ratings_id.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/presentation/features/home/home_page.dart';
import 'package:flavormate/presentation/features/library/library_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/recipe_editor_item_page.dart';
import 'package:flavormate/presentation/features/recipes_item/models/p_recipe_wrapper.dart';
import 'package:flavormate/presentation/features/recipes_item/providers/p_recipes_item_page.dart';
import 'package:flavormate/presentation/features/recipes_item/recipes_item_page.dart';
import 'package:flavormate/presentation/features/settings/settings_account/settings_account_diet/settings_account_diet_page.dart';
import 'package:flavormate/presentation/features/settings/settings_app/subpages/theme/settings_app_theme_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'disk_asset_bundle.dart';
import 'main_test_layout.dart';
import 'test_data/accounts/accounts.dart';
import 'test_data/books/books.dart';
import 'test_data/highlights/highlights.dart';
import 'test_data/recipes/recipes.dart';
import 'test_data/stories/stories.dart';
import 'u_screenshot.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final assets = await DiskAssetBundle.loadFromPath('test/_resources/');

  group('Screenshot ENG:', () {
    const locale = Locale("en");
    screenshotRecipeItemPage(locale, assets);
    screenshotHomePage(locale, assets);
    screenshotLibraryPage(locale, assets);
    screenshotRecipeEditorPage(locale, assets);
    screenshotSettingsAccountDietPage(locale, assets);
    screenshotSettingsAppThemePage(locale, assets);
  });

  group('Screenshot DE:', () {
    const locale = Locale("de");
    screenshotRecipeItemPage(locale, assets);
    screenshotHomePage(locale, assets);
    screenshotLibraryPage(locale, assets);
    screenshotRecipeEditorPage(locale, assets);
    screenshotSettingsAccountDietPage(locale, assets);
    screenshotSettingsAppThemePage(locale, assets);
  });
}

void screenshotRecipeItemPage(Locale locale, AssetBundle assets) {
  final overrides = [
    pRecipesItemPageProvider.overrideWithBuild(
      (ref, it) => PRecipePageWrapper(
        recipe: CommonRecipe.fromRecipe(
          RecipeFulls.r_9fa077d3_af00_4ec1_ab7e_c27f8cd92920[locale]!(),
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

  UScreenshot.screenshot(
    '0a_recipe_top',
    locale: locale,
    assets: assets,
    home: ProviderScope(
      overrides: overrides,
      child: RecipesItemPage(id: 'id'),
    ),
  );

  UScreenshot.screenshot(
    '0b_recipe_middle',
    locale: locale,
    assets: assets,
    beforeScreenshot: (tester) async {
      final scrollable = find
          .descendant(
            of: find.byKey(ValueKey('page-scrollable')),
            matching: find.byType(Scrollable),
          )
          .first;

      await tester.scrollUntilVisible(
        find.byKey(ValueKey("ingredient-header")),
        25,
        scrollable: scrollable,
      );

      await tester.pump(Duration(seconds: 2));
    },
    home: ProviderScope(
      overrides: overrides,
      child: RecipesItemPage(id: 'id'),
    ),
  );

  UScreenshot.screenshot(
    '0c_recipe_bottom',
    locale: locale,
    assets: assets,
    beforeScreenshot: (tester) async {
      final scrollable = find
          .descendant(
            of: find.byKey(ValueKey('page-scrollable')),
            matching: find.byType(Scrollable),
          )
          .first;

      await tester.scrollUntilVisible(
        find.byKey(ValueKey("category-header")),
        25,
        scrollable: scrollable,
      );

      await tester.pump(const Duration(seconds: 2));
    },
    home: ProviderScope(
      overrides: overrides,
      child: RecipesItemPage(id: 'id'),
    ),
  );
}

void screenshotHomePage(Locale locale, AssetBundle assets) {
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

  UScreenshot.screenshot(
    '1_home',
    locale: locale,
    assets: assets,
    home: ProviderScope(
      overrides: [
        pFeatureStoryProvider.overrideWithValue(true),
        pRestAccountsSelfProvider.overrideWithBuild(
          (ref, it) => account,
        ),
        pRestStoriesProvider.overrideWithBuild(
          (ref, it) => PageableDto(
            metadata: Metadata(
              totalElements: stories.length,
              pageSize: stories.length,
              currentPage: 1,
              totalPages: 1,
            ),
            data: stories,
          ),
        ),
        pRestHighlightsProvider.overrideWithBuild(
          (ref, it) => PageableDto(
            metadata: Metadata(
              totalElements: highlights.length,
              pageSize: highlights.length,
              currentPage: 1,
              totalPages: 1,
            ),
            data: highlights,
          ),
        ),
        pRestRecipesProvider.overrideWithBuild(
          (ref, it) => PageableDto<RecipePreviewDto>(
            metadata: Metadata(
              totalElements: newestRecipes.length,
              pageSize: newestRecipes.length,
              currentPage: 1,
              totalPages: 1,
            ),
            data: newestRecipes,
          ),
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
      ],
      child: const MainTestLayout(
        activeIndex: 0,
        child: HomePage(),
      ),
    ),
  );
}

void screenshotLibraryPage(Locale locale, AssetBundle assets) {
  final account = AccountFulls.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc;

  final books = Books.getByOrder(
    locale,
    (a, b) => a.label.compareToIgnoreCase(b.label),
  );

  UScreenshot.screenshot(
    '2_library',
    locale: locale,
    assets: assets,
    home: ProviderScope(
      overrides: [
        pRestAccountsSelfProvider.overrideWithBuild(
          (ref, it) => account,
        ),
        pRestBooksProvider.overrideWithBuild(
          (ref, it) => PageableDto(
            metadata: Metadata(
              totalElements: books.length,
              pageSize: books.length,
              currentPage: 1,
              totalPages: 1,
            ),
            data: books,
          ),
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
      ],
      child: const MainTestLayout(
        activeIndex: 1,
        child: LibraryPage(),
      ),
    ),
  );
}

void screenshotRecipeEditorPage(Locale locale, AssetBundle assets) {
  UScreenshot.screenshot(
    '3_recipe_editor',
    locale: locale,
    assets: assets,
    brightness: .dark,
    home: ProviderScope(
      overrides: [
        pRestRecipeDraftsIdProvider.overrideWithBuild(
          (ref, it) => RecipeDraftFullDto(
            id: 'id',
            version: 0,
            createdOn: DateTime.now(),
            lastModifiedOn: DateTime.now(),
            label: null,
            originId: null,
            ownedBy: AccountPreviews.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
            description: null,
            prepTime: Duration.zero,
            cookTime: Duration.zero,
            restTime: Duration.zero,
            serving: RecipeDraftServingDto(id: 'id', amount: null, label: null),
            ingredientGroups: [],
            instructionGroups: [],
            categories: [],
            tags: [],
            course: null,
            diet: null,
            url: null,
            files: [],
          ),
        ),
      ],
      child: RecipeEditorItemPage(id: ''),
    ),
  );
}

void screenshotSettingsAccountDietPage(Locale locale, AssetBundle assets) {
  UScreenshot.screenshot(
    '4_account_diet',
    locale: locale,
    assets: assets,
    brightness: .dark,
    home: ProviderScope(
      overrides: [
        pRestAccountsSelfProvider.overrideWithBuild(
          (ref, it) => AccountFulls.a_d6fc559f_ddc1_4bc2_a9c1_c8a17ff5ffcc,
        ),
      ],
      child: SettingsAccountDietPage(),
    ),
  );
}

void screenshotSettingsAppThemePage(Locale locale, AssetBundle assets) {
  final userColor = Colors.pink;
  UScreenshot.screenshot(
    '5_theme',
    locale: locale,
    assets: assets,
    brightness: .dark,
    primaryColor: userColor,
    home: ProviderScope(
      overrides: [
        pSPThemeToneProvider.overrideWithValue(.vivid),
        // Sets mode to user selected color
        pSPThemeModeProvider.overrideWithValue(.custom),
        // Mocks the system theme color
        pDynamicColorProvider.overrideWithValue(Colors.orange),
        // Mocks the user selected color
        pSPThemeCustomColorProvider.overrideWithValue(userColor),
      ],
      child: SettingsAppThemePage(),
    ),
  );
}
