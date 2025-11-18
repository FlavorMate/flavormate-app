import 'package:flavormate/core/constants/route_constants.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/presentation/common/layouts/main_layout.dart';
import 'package:flavormate/presentation/common/widgets/go_router/wrapper.dart';
import 'package:flavormate/presentation/features/accounts_item/accounts_item_page.dart';
import 'package:flavormate/presentation/features/accounts_item/subpages/accounts_item_books_page.dart';
import 'package:flavormate/presentation/features/accounts_item/subpages/accounts_item_recipes_page.dart';
import 'package:flavormate/presentation/features/accounts_item/subpages/accounts_item_stories_page.dart';
import 'package:flavormate/presentation/features/administration/account_management/administration_account_management_page.dart';
import 'package:flavormate/presentation/features/auth/auth_page.dart';
import 'package:flavormate/presentation/features/auth/subpages/auth_login/auth_login_page.dart';
import 'package:flavormate/presentation/features/auth/subpages/auth_recovery/auth_recovery_page.dart';
import 'package:flavormate/presentation/features/auth/subpages/auth_register/auth_register_page.dart';
import 'package:flavormate/presentation/features/categories/categories_page.dart';
import 'package:flavormate/presentation/features/categories_item/categories_item_page.dart';
import 'package:flavormate/presentation/features/home/home_page.dart';
import 'package:flavormate/presentation/features/home/subpages/home_highlights_page.dart';
import 'package:flavormate/presentation/features/home/subpages/home_latest_page.dart';
import 'package:flavormate/presentation/features/home/subpages/home_stories_page.dart';
import 'package:flavormate/presentation/features/library/library_page.dart';
import 'package:flavormate/presentation/features/library_item/library_item_page.dart';
import 'package:flavormate/presentation/features/more/more_page.dart';
import 'package:flavormate/presentation/features/no_connection/no_connection_page.dart';
import 'package:flavormate/presentation/features/recipe_editor/recipe_editor.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/recipe_editor_item_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_categories/recipe_editor_item_categories_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_common/recipe_editor_item_common_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_durations/recipe_editor_item_durations_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_files/recipe_editor_item_files_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups/recipe_editor_item_ingredient_groups_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item/recipe_editor_item_ingredient_groups_item_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_ingredient_groups_item_ingredient/recipe_editor_item_ingredient_groups_item_ingredient_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups/recipe_editor_item_instruction_groups_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups_item/recipe_editor_item_instruction_groups_item_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups_item_instruction/recipe_editor_item_instruction_groups_item_instruction_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_origin/recipe_editor_item_origin_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_preview/recipe_editor_item_preview_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_preview/subpages/recipe_editor_item_preview_files/recipe_editor_item_preview_files_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_serving/recipe_editor_item_serving_page.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_tags/recipe_editor_item_tags.dart';
import 'package:flavormate/presentation/features/recipes/recipes_page.dart';
import 'package:flavormate/presentation/features/recipes_item/recipes_item_page.dart';
import 'package:flavormate/presentation/features/recipes_item/subpages/recipes_item_files_page.dart';
import 'package:flavormate/presentation/features/server/server_page.dart';
import 'package:flavormate/presentation/features/server_outdated/server_outdated_page.dart';
import 'package:flavormate/presentation/features/settings/settings_page.dart';
import 'package:flavormate/presentation/features/settings/subpages/image_mode/settings_image_mode_page.dart';
import 'package:flavormate/presentation/features/settings/subpages/theme/settings_theme_page.dart';
import 'package:flavormate/presentation/features/splash/splash_page.dart';
import 'package:flavormate/presentation/features/stories_item/stories_item_page.dart';
import 'package:flavormate/presentation/features/story_editor/story_editor_page.dart';
import 'package:flavormate/presentation/features/story_editor_item/story_editor_item_page.dart';
import 'package:flavormate/presentation/features/story_editor_item/subpages/story_editor_item_preview_page.dart';
import 'package:flavormate/presentation/features/suggestion/suggestion_page.dart';
import 'package:flavormate/presentation/features/tags/tags_page.dart';
import 'package:flavormate/presentation/features/tags_item/tags_item_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

var routes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return Wrapper(child: MainLayout(navigationShell: navigationShell));
    },
    branches: [
      StatefulShellBranch(
        routes: [_createRoute(RouteConstants.Home, (_) => const HomePage())],
      ),
      StatefulShellBranch(
        routes: [
          _createRoute(RouteConstants.Library, (_) => const LibraryPage()),
        ],
      ),
      StatefulShellBranch(
        routes: [_createRoute(RouteConstants.More, (_) => const MorePage())],
      ),
      StatefulShellBranch(
        routes: [
          _createRoute(RouteConstants.Settings, (_) => const SettingsPage()),
        ],
      ),
    ],
  ),

  // Auth not required
  _createRoute(RouteConstants.Server, (_) => const ServerPage()),
  _createRoute(RouteConstants.Auth, (_) => const LoginPage()),
  _createRoute(RouteConstants.AuthLogin, (_) => const AuthLoginPage()),
  _createRoute(RouteConstants.AuthRegister, (_) => const AuthRegisterPage()),
  _createRoute(RouteConstants.AuthRecovery, (_) => const AuthRecoveryPage()),

  // Auth required
  _createRoute(RouteConstants.Splash, (_) => const SplashPage()),

  // Home
  _createRoute(RouteConstants.HomeStories, (_) => const HomeStoriesPage()),
  _createRoute(
    RouteConstants.HomeHighlights,
    (_) => const HomeHighlightsPage(),
  ),
  _createRoute(RouteConstants.HomeLatest, (_) => const HomeLatestPage()),

  // Suggestion
  _createRoute(
    RouteConstants.Suggestion,
    (params) => SuggestionPage(
      course: params['course']?.let((it) => CourseMapper.fromValue(it)),
    ),
  ),

  // Library
  _createRoute(
    RouteConstants.LibraryItem,
    (params) => LibraryItemPage(id: params['id']!),
  ),

  // Misc
  _createRoute(RouteConstants.NoConnection, (_) => const NoConnectionPage()),
  _createRoute(
    RouteConstants.ServerOutdated,
    (_) => const ServerOutdatedPage(),
  ),

  // Settings
  _createRoute(RouteConstants.SettingsTheme, (_) => const SettingsThemePage()),
  _createRoute(
    RouteConstants.SettingsImageMode,
    (_) => const SettingsImageModePage(),
  ),

  // Admin
  _createRoute(
    RouteConstants.AdministrationAccountManagement,
    (_) => const AdministrationAccountManagementPage(),
  ),

  // Recipe
  _createRoute(RouteConstants.Recipes, (_) => const RecipesPage()),
  _createRoute(
    RouteConstants.RecipesItem,
    (params) => RecipesItemPage(
      id: params['id']!,
    ),
  ),
  _createRoute(
    RouteConstants.RecipesItemFiles,
    (params) => RecipesItemFilesPage(id: params['id']!),
  ),

  // Categories
  _createRoute(RouteConstants.Categories, (_) => const CategoriesPage()),
  _createRoute(
    RouteConstants.CategoriesItem,
    (params) => CategoriesItemPage(
      id: params['id']!,
    ),
  ),

  // Tags
  _createRoute(RouteConstants.Tags, (_) => const TagsPage()),
  _createRoute(
    RouteConstants.TagsItem,
    (params) => TagsItemPage(id: params['id']!),
  ),

  // Accounts
  // TODO: Add Accounts page
  // _createRoute(RouteConstants.Accounts, (_) => const AccountsPage()),
  _createRoute(
    RouteConstants.AccountsItem,
    (params) => AccountsItemPage(id: params['id']!),
  ),
  _createRoute(
    RouteConstants.AccountsItemBooks,
    (params) => AccountsItemBooksPage(id: params['id']!),
  ),
  _createRoute(
    RouteConstants.AccountsItemRecipes,
    (params) => AccountsItemRecipesPage(id: params['id']!),
  ),
  _createRoute(
    RouteConstants.AccountsItemStories,
    (params) => AccountsItemStoriesPage(id: params['id']!),
  ),

  // Recipe Editor
  _createRoute(RouteConstants.RecipeEditor, (_) => const RecipeEditorPage()),
  _createRoute(
    RouteConstants.RecipeEditorItem,
    (params) => RecipeEditorItemPage(id: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemCommon,
    (params) => RecipeEditorItemCommonPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemServing,
    (params) => RecipeEditorItemServingPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemDurations,
    (params) => RecipeEditorItemDurationsPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemIngredientGroups,
    (params) =>
        RecipeEditorItemIngredientGroupsPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemIngredientGroupsItem,
    (params) => RecipeEditorItemIngredientGroupsItemPage(
      draftId: params['draftId']!,
      ingredientGroupId: params['ingredientGroupId']!,
    ),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemIngredientGroupsItemIngredient,
    (params) => RecipeEditorItemIngredientGroupsItemIngredientPage(
      draftId: params['draftId']!,
      ingredientGroupId: params['ingredientGroupId']!,
      ingredientId: params['ingredientId']!,
    ),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemInstructionGroups,
    (params) =>
        RecipeEditorItemInstructionGroupsPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemInstructionGroupsItem,
    (params) => RecipeEditorItemInstructionGroupsItemPage(
      draftId: params['draftId']!,
      instructionGroupId: params['instructionGroupId']!,
    ),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemInstructionGroupsItemInstruction,
    (params) => RecipeEditorItemInstructionGroupsItemInstructionPage(
      draftId: params['draftId']!,
      instructionGroupId: params['instructionGroupId']!,
      instructionId: params['instructionId']!,
    ),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemTags,
    (params) => RecipeEditorItemTagsPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemCategories,
    (params) => RecipeEditorItemCategoriesPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemFiles,
    (params) => RecipeEditorItemFilesPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemOrigin,
    (params) => RecipeEditorItemOriginPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemPreview,
    (params) => RecipeEditorItemPreviewPage(draftId: params['draftId']!),
  ),
  _createRoute(
    RouteConstants.RecipeEditorItemPreviewFiles,
    (params) => RecipeEditorItemPreviewFilesPage(
      draftId: params['draftId']!,
    ),
  ),

  // Stories
  _createRoute(
    RouteConstants.StoriesItem,
    (params) => StoriesItemPage(id: params['id']!),
  ),

  // Story Editor
  _createRoute(RouteConstants.StoryEditor, (_) => const StoryEditorPage()),
  _createRoute(
    RouteConstants.StoryEditorItem,
    (params) => StoryEditorItemPage(id: params['id']!),
  ),
  _createRoute(
    RouteConstants.StoryEditorItemPreview,
    (params) => StoryEditorItemPreviewPage(id: params['id']!),
  ),
];

GoRoute _createRoute(
  RouteConstant constant,
  Widget Function(Map<String, String>) selector,
) {
  return GoRoute(
    path: constant.route,
    name: constant.name,
    pageBuilder: (context, state) =>
        MaterialPage(child: selector.call(state.pathParameters)),
  );
}
