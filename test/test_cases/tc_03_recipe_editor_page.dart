import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/recipe_editor_item_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_data/recipe_draft/recipe_drafts.dart';
import 'tc.dart';

class TC03RecipeEditorPage extends TC {
  const TC03RecipeEditorPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides => [
    pRestRecipeDraftsIdProvider.overrideWithBuild(
      (ref, it) => RecipeDrafts.rd_0,
    ),
  ];

  @override
  void run() {
    screenshot(
      '3_recipe_editor',
      RecipeEditorItemPage(id: RecipeDrafts.rd_0.id),
    );
  }
}
