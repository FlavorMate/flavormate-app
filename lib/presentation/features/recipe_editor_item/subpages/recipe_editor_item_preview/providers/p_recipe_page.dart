import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_page.g.dart';

@riverpod
class PRecipeEditorPreviewPage extends _$PRecipeEditorPreviewPage {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(id);

  @override
  Future<CommonRecipe> build(String id) async {
    final draft = await ref.watch(_parentProvider.future);

    return CommonRecipe.fromDraft(draft);
  }

  Future<ApiResponse<void>> upload() async {
    return await ref.read(_parentProvider.notifier).upload();
  }
}
