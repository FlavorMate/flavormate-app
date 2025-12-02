import 'package:flavormate/core/constants/route_constants.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_jwt.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth_state.g.dart';

/// The current authentication state of the app.
///
/// This notifier is responsible for saving/removing the token and profile info
/// to the storage through the [Login] and [logout] methods.
@riverpod
class PAuthState extends _$PAuthState {
  @override
  AuthState build() {
    final jwt = ref.watch(pSPJwtProvider);

    return jwt != null ? AuthState.authenticated : AuthState.unauthenticated;
  }
}

/// The possible authentication states of the app.
enum AuthState {
  unknown(
    redirectPath: RouteConstants.root,
    allowedPaths: [RouteConstants.root],
  ),
  unauthenticated(
    redirectPath: RouteConstants.Auth,
    allowedPaths: [
      RouteConstants.Auth,
      RouteConstants.AuthLogin,
      RouteConstants.AuthRegister,
      RouteConstants.Server,
      RouteConstants.AuthRecovery,
      RouteConstants.Registration,
    ],
  ),
  authenticated(
    redirectPath: RouteConstants.Splash,
    allowedPaths: [
      RouteConstants.Splash,
      RouteConstants.Home,
      RouteConstants.HomeStories,
      RouteConstants.HomeHighlights,
      RouteConstants.HomeLatest,
      // Library
      RouteConstants.Library,
      RouteConstants.LibraryItem,

      // More
      RouteConstants.More,

      // Settings
      RouteConstants.SettingsAccount,
      RouteConstants.SettingsApp,
      RouteConstants.SettingsAppTheme,
      RouteConstants.SettingsAppImageMode,

      // Misc
      RouteConstants.NoConnection,
      RouteConstants.ServerOutdated,

      // Suggestion
      RouteConstants.Suggestion,

      // Recipes
      RouteConstants.Recipes,
      RouteConstants.RecipesItem,
      RouteConstants.RecipesItemFiles,

      // Categories
      RouteConstants.Categories,
      RouteConstants.CategoriesItem,

      // Tags
      RouteConstants.Tags,
      RouteConstants.TagsItem,

      // Accounts
      RouteConstants.Accounts,
      RouteConstants.AccountsItem,
      RouteConstants.AccountsItemBooks,
      RouteConstants.AccountsItemRecipes,
      RouteConstants.AccountsItemStories,

      // Recipe Editor
      RouteConstants.RecipeEditor,
      RouteConstants.RecipeEditorItem,
      RouteConstants.RecipeEditorItemCommon,
      RouteConstants.RecipeEditorItemServing,
      RouteConstants.RecipeEditorItemDurations,
      RouteConstants.RecipeEditorItemIngredientGroups,
      RouteConstants.RecipeEditorItemIngredientGroupsItem,
      RouteConstants.RecipeEditorItemIngredientGroupsItemIngredient,
      RouteConstants.RecipeEditorItemInstructionGroups,
      RouteConstants.RecipeEditorItemInstructionGroupsItem,
      RouteConstants.RecipeEditorItemInstructionGroupsItemInstruction,
      RouteConstants.RecipeEditorItemTags,
      RouteConstants.RecipeEditorItemCategories,
      RouteConstants.RecipeEditorItemFiles,
      RouteConstants.RecipeEditorItemOrigin,
      RouteConstants.RecipeEditorItemPreview,
      RouteConstants.RecipeEditorItemPreviewFiles,

      // Stories
      RouteConstants.StoriesItem,

      // Story Editor
      RouteConstants.StoryEditor,
      RouteConstants.StoryEditorItem,
      RouteConstants.StoryEditorItemPreview,

      // Admin pages
      RouteConstants.AdministrationAccountManagement,
      // '/admin/user',
      // '/admin/share',
    ],
  )
  ;

  const AuthState({required this.redirectPath, required this.allowedPaths});

  /// The target path to redirect when the current route is not allowed in this
  /// auth state.
  final RouteConstant redirectPath;

  /// List of paths allowed when the app is in this auth state.
  final List<RouteConstant> allowedPaths;

  bool routeIsAllowed(String? fullPath) {
    if (fullPath == null) return false;
    return allowedPaths.any((allowedPath) => allowedPath.route == fullPath);
  }
}
