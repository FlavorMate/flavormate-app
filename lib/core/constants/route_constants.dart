abstract class RouteConstants {
  static const RouteConstant root = RouteConstant(
    '/',
    '',
  );

  // Auth not required
  static const RouteConstant Server = RouteConstant(
    '/server',
    'server',
  );
  static const RouteConstant Auth = RouteConstant(
    '/auth',
    'auth',
  );
  static const RouteConstant AuthLogin = RouteConstant(
    '/auth/login',
    'auth_login',
  );
  static const RouteConstant AuthRegister = RouteConstant(
    '/auth/register',
    'auth_register',
  );
  static const RouteConstant AuthRecovery = RouteConstant(
    '/auth/recovery',
    'auth_recovery',
  );
  static const RouteConstant Registration = RouteConstant(
    '/registration',
    'registration',
  );

  // Auth required
  static const RouteConstant Splash = RouteConstant(
    '/splash',
    'splash',
  );
  static const RouteConstant Home = RouteConstant(
    '/home',
    'home',
  );
  static const RouteConstant HomeStories = RouteConstant(
    '/home/stories',
    'home_stories',
  );

  static const RouteConstant HomeHighlights = RouteConstant(
    '/home/highlights',
    'home_highlights',
  );

  static const RouteConstant HomeLatest = RouteConstant(
    '/home/latest',
    'home_latest',
  );

  static const RouteConstant Suggestion = RouteConstant(
    '/home/suggestion/:course',
    'home_suggestion',
  );

  // Library
  static const RouteConstant Library = RouteConstant(
    '/library',
    'library',
  );
  static const RouteConstant LibraryItem = RouteConstant(
    '/library/:id',
    'library_item',
  );

  // More
  static const RouteConstant More = RouteConstant(
    '/more',
    'more',
  );

  // Settings
  static const RouteConstant Settings = RouteConstant(
    '/settings',
    'settings',
  );
  static const RouteConstant SettingsTheme = RouteConstant(
    '/settings/theme',
    'settings_theme',
  );
  static const RouteConstant SettingsImageMode = RouteConstant(
    '/settings/image-mode',
    'settings_image-mode',
  );

  // Misc
  static const RouteConstant NoConnection = RouteConstant(
    '/no-connection',
    'no-connection',
  );
  static const RouteConstant ServerOutdated = RouteConstant(
    '/server-outdated',
    'server-outdated',
  );

  // Recipe
  static const RouteConstant Recipes = RouteConstant(
    '/recipes',
    'recipes',
  );
  static const RouteConstant RecipesItem = RouteConstant(
    '/recipes/:id',
    'recipes_item',
  );
  static const RouteConstant RecipesItemFiles = RouteConstant(
    '/recipes/:id/files',
    'recipes_item_files',
  );

  // Categories
  static const RouteConstant Categories = RouteConstant(
    '/categories',
    'categories',
  );
  static const RouteConstant CategoriesItem = RouteConstant(
    '/categories/:id',
    'categories_item',
  );

  // Categories
  static const RouteConstant Tags = RouteConstant(
    '/tags',
    'tags',
  );
  static const RouteConstant TagsItem = RouteConstant(
    '/tags/:id',
    'tags_item',
  );

  // Accounts
  static const RouteConstant Accounts = RouteConstant(
    '/accounts',
    'accounts',
  );
  static const RouteConstant AccountsItem = RouteConstant(
    '/accounts/:id',
    'accounts_item',
  );
  static const RouteConstant AccountsItemBooks = RouteConstant(
    '/accounts/:id/books',
    'accounts_item_books',
  );
  static const RouteConstant AccountsItemRecipes = RouteConstant(
    '/accounts/:id/recipes',
    'accounts_item_recipes',
  );
  static const RouteConstant AccountsItemStories = RouteConstant(
    '/accounts/:id/stories',
    'accounts_item_stories',
  );

  // Recipe Editor
  static const RouteConstant RecipeEditor = RouteConstant(
    '/recipe-editor',
    'recipe-editor',
  );
  static const RouteConstant RecipeEditorItem = RouteConstant(
    '/recipe-editor/:draftId',
    'recipe-editor_item',
  );
  static const RouteConstant RecipeEditorItemCommon = RouteConstant(
    '/recipe-editor/:draftId/common',
    'recipe-editor_item_common',
  );
  static const RouteConstant RecipeEditorItemServing = RouteConstant(
    '/recipe-editor/:draftId/serving',
    'recipe-editor_item_serving',
  );
  static const RouteConstant RecipeEditorItemDurations = RouteConstant(
    '/recipe-editor/:draftId/durations',
    'recipe-editor_item_durations',
  );
  static const RouteConstant RecipeEditorItemIngredientGroups = RouteConstant(
    '/recipe-editor/:draftId/ingredient-groups',
    'recipe-editor_item_ingredient-groups',
  );
  static const RouteConstant RecipeEditorItemIngredientGroupsItem =
      RouteConstant(
        '/recipe-editor/:draftId/ingredient-groups/:ingredientGroupId',
        'recipe-editor_item_ingredient-groups_item',
      );
  static const RouteConstant
  RecipeEditorItemIngredientGroupsItemIngredient = RouteConstant(
    '/recipe-editor/:draftId/ingredient-groups/:ingredientGroupId/ingredient/:ingredientId',
    'recipe-editor_item_ingredient-groups_item_ingredient',
  );

  static const RouteConstant RecipeEditorItemInstructionGroups = RouteConstant(
    '/recipe-editor/:draftId/instruction-groups',
    'recipe-editor_item_instruction-groups',
  );
  static const RouteConstant RecipeEditorItemInstructionGroupsItem =
      RouteConstant(
        '/recipe-editor/:draftId/instruction-groups/:instructionGroupId',
        'recipe-editor_item_instruction-groups_item',
      );
  static const RouteConstant
  RecipeEditorItemInstructionGroupsItemInstruction = RouteConstant(
    '/recipe-editor/:draftId/instruction-groups/:instructionGroupId/instruction/:instructionId',
    'recipe-editor_item_instruction-groups_item_instruction',
  );
  static const RouteConstant RecipeEditorItemTags = RouteConstant(
    '/recipe-editor/:draftId/tags',
    'recipe-editor_item_tags',
  );
  static const RouteConstant RecipeEditorItemCategories = RouteConstant(
    '/recipe-editor/:draftId/categories',
    'recipe-editor_item_categories',
  );
  static const RouteConstant RecipeEditorItemFiles = RouteConstant(
    '/recipe-editor/:draftId/files',
    'recipe-editor_item_files',
  );
  static const RouteConstant RecipeEditorItemOrigin = RouteConstant(
    '/recipe-editor/:draftId/origin',
    'recipe-editor_item_origin',
  );
  static const RouteConstant RecipeEditorItemPreview = RouteConstant(
    '/recipe-editor/:draftId/preview',
    'recipe-editor_item_preview',
  );
  static const RouteConstant RecipeEditorItemPreviewFiles = RouteConstant(
    '/recipe-editor/:draftId/preview/files',
    'recipe-editor_item_preview_files',
  );

  // Stories
  static const RouteConstant StoriesItem = RouteConstant(
    '/stories/:id',
    'stories_item',
  );

  // Story Editor
  static const RouteConstant StoryEditor = RouteConstant(
    '/story-editor',
    'story-editor',
  );
  static const RouteConstant StoryEditorItem = RouteConstant(
    '/story-editor/:id',
    'story-editor_item',
  );
  static const RouteConstant StoryEditorItemPreview = RouteConstant(
    '/story-editor/:id/preview',
    'story-editor_item_preview',
  );

  // Admin Pages
  static const RouteConstant AdministrationAccountManagement = RouteConstant(
    '/administration/account-management',
    'administration-account-management',
  );
}

class RouteConstant {
  final String route;
  final String name;

  const RouteConstant(this.route, this.name);
}
