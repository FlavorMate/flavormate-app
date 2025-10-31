import 'package:flavormate/core/constants/route_constants.dart';
import 'package:flavormate/core/theme/models/blended_colors.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/presentation/common/dialogs/f_loading_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel_full_view.dart';
import 'package:flavormate/presentation/common/widgets/f_image/f_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension EBuildContext on BuildContext {
  /// A convenient way to access [ThemeData.colorScheme] of the current context.
  ///
  /// This also prevents confusion with a bunch of other properties of [ThemeData]
  /// that are less commonly used.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  BlendedColors get blendedColors => Theme.of(this).extension<BlendedColors>()!;

  /// A convenient way to access [ThemeData.textTheme] of the current context.
  ///
  /// This also prevents confusion with a bunch of other properties of [ThemeData]
  /// that are less commonly used.
  TextTheme get textTheme => Theme.of(this).textTheme;

  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  Routes get routes => Routes(this);

  /// Shows a floating snack bar with text as its content.
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showTextSnackBar(
    String text, {
    Color? color,
  }) => ScaffoldMessenger.of(this).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      content: Text(text),
    ),
  );

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showErrorSnackBar(
    String text,
  ) => ScaffoldMessenger.of(this).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: blendedColors.error,
      content: Text(text),
    ),
  );

  void showAppLicensePage() => showLicensePage(
    context: this,
    useRootNavigator: true,
    applicationName: 'DummyMart',
  );

  Future<void> showFullscreenImage(String url) {
    return showDialog(
      context: this,
      useSafeArea: false,
      builder: (_) => FCarouselFullView(
        url: url,
        imageType: FImageType.secure,
      ),
    );
  }

  /// Custom call a provider for reading method only
  /// It will be helpful for us for calling the read function
  /// without Consumer,ConsumerWidget or ConsumerStatefulWidget
  /// In case if you face any issue using this then please wrap your widget
  /// with consumer and then call your provider
  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  /// Shows a loading dialog that can be dismissed via [Navigator.pop].
  void showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: this,
      builder: (_) => const FLoadingDialog(),
    );
  }
}

extension ThemeModeX on ThemeMode {
  String get label => switch (this) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };
}

class Routes {
  final BuildContext context;

  Routes(this.context);

  Future categoriesItem(String id) {
    return context.pushNamed(
      RouteConstants.CategoriesItem.name,
      pathParameters: {'id': id},
    );
  }

  Future recipesItem(String id) {
    return context.pushNamed(
      RouteConstants.RecipesItem.name,
      pathParameters: {'id': id},
    );
  }

  Future recipesItemFiles(String id) {
    return context.pushNamed(
      RouteConstants.RecipesItemFiles.name,
      pathParameters: {'id': id},
    );
  }

  Future tagsItem(String id) {
    return context.pushNamed(
      RouteConstants.TagsItem.name,
      pathParameters: {'id': id},
    );
  }

  Future libraryItem(String id) {
    return context.pushNamed(
      RouteConstants.LibraryItem.name,
      pathParameters: {'id': id},
    );
  }

  Future storiesItem(String id) {
    return context.pushNamed(
      RouteConstants.StoriesItem.name,
      pathParameters: {'id': id},
    );
  }

  Future recipes() {
    return context.pushNamed(RouteConstants.Recipes.name);
  }

  Future accountsItem(String id) {
    return context.pushNamed(
      RouteConstants.AccountsItem.name,
      pathParameters: {'id': id},
    );
  }

  Future server({bool replace = false}) async {
    if (replace) {
      context.pushReplacementNamed(RouteConstants.Server.name);
      return;
    } else {
      return context.pushNamed(RouteConstants.Server.name);
    }
  }

  Future login({bool replace = false}) async {
    if (replace) {
      context.pushReplacementNamed(RouteConstants.Auth.name);
      return;
    } else {
      return context.pushNamed(RouteConstants.Auth.name);
    }
  }

  Future recovery() {
    return context.pushNamed(RouteConstants.AuthRecovery.name);
  }

  Future registration() {
    return context.pushNamed(RouteConstants.AuthRegister.name);
  }

  Future storyEditorItem(String id) {
    return context.pushNamed(
      RouteConstants.StoryEditorItem.name,
      pathParameters: {'id': id},
    );
  }

  Future home({bool replace = false}) async {
    if (replace) {
      return context.goNamed(RouteConstants.Home.name);
    } else {
      return context.pushNamed(RouteConstants.Home.name);
    }
  }

  Future accountsItemStories(String id) {
    return context.pushNamed(
      RouteConstants.AccountsItemStories.name,
      pathParameters: {'id': id},
    );
  }

  Future accountsItemBooks(String id) {
    return context.pushNamed(
      RouteConstants.AccountsItemBooks.name,
      pathParameters: {'id': id},
    );
  }

  Future accountsItemRecipes(String id) {
    return context.pushNamed(
      RouteConstants.AccountsItemRecipes.name,
      pathParameters: {'id': id},
    );
  }

  Future homeStories() {
    return context.pushNamed(RouteConstants.HomeStories.name);
  }

  Future homeHighlights() {
    return context.pushNamed(RouteConstants.HomeHighlights.name);
  }

  Future homeLatest() {
    return context.pushNamed(RouteConstants.HomeLatest.name);
  }

  Future recipeEditorItem(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItem.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemCommon(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemCommon.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemServing(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemServing.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemDurations(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemDurations.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemIngredientGroups(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemIngredientGroups.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemIngredientGroupsItem(
    String draftId,
    String ingredientGroupId,
  ) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemIngredientGroupsItem.name,
      pathParameters: {
        'draftId': draftId,
        'ingredientGroupId': ingredientGroupId,
      },
    );
  }

  Future recipeEditorItemIngredientGroupsItemIngredient(
    String draftId,
    String ingredientGroupId,
    String ingredientId,
  ) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemIngredientGroupsItemIngredient.name,
      pathParameters: {
        'draftId': draftId,
        'ingredientGroupId': ingredientGroupId,
        'ingredientId': ingredientId,
      },
    );
  }

  Future recipeEditorItemInstructionGroups(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemInstructionGroups.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemInstructionGroupsItem(
    String draftId,
    String instructionGroupId,
  ) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemInstructionGroupsItem.name,
      pathParameters: {
        'draftId': draftId,
        'instructionGroupId': instructionGroupId,
      },
    );
  }

  Future recipeEditorItemInstructionGroupsItemInstruction(
    String draftId,
    String instructionGroupId,
    String instructionId,
  ) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemInstructionGroupsItemInstruction.name,
      pathParameters: {
        'draftId': draftId,
        'instructionGroupId': instructionGroupId,
        'instructionId': instructionId,
      },
    );
  }

  Future recipeEditorItemTags(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemTags.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemCategories(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemCategories.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemFiles(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemFiles.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemPreview(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemPreview.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future recipeEditorItemPreviewFiles(String draftId) {
    return context.pushNamed(
      RouteConstants.RecipeEditorItemPreviewFiles.name,
      pathParameters: {'draftId': draftId},
    );
  }

  Future serverOutdated() async {
    return context.replaceNamed(RouteConstants.ServerOutdated.name);
  }

  Future categories() {
    return context.pushNamed(RouteConstants.Categories.name);
  }

  Future tags() {
    return context.pushNamed(RouteConstants.Tags.name);
  }

  Future recipeEditor() {
    return context.pushNamed(RouteConstants.RecipeEditor.name);
  }

  Future storyEditor() {
    return context.pushNamed(RouteConstants.StoryEditor.name);
  }

  Future splash({required bool replace}) async {
    if (replace) {
      return context.goNamed(RouteConstants.Splash.name);
    } else {
      return context.pushNamed(RouteConstants.Splash.name);
    }
  }

  Future settingsChangelog() {
    return context.pushNamed(RouteConstants.SettingsChangelog.name);
  }

  Future settingsTheme() {
    return context.pushNamed(RouteConstants.SettingsTheme.name);
  }

  Future storyEditorItemPreview(String id) async {
    return context.pushNamed(
      RouteConstants.StoryEditorItemPreview.name,
      pathParameters: {'id': id},
    );
  }

  Future administrationAccountManagement() {
    return context.pushNamed(
      RouteConstants.AdministrationAccountManagement.name,
    );
  }

  Future suggestion(Course? course) async {
    final params = <String, String>{};

    if (course != null) {
      params['course'] = course.name;
    }

    return context.pushNamed(
      RouteConstants.Suggestion.name,
      pathParameters: params,
    );
  }
}
