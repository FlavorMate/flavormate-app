import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_categories.g.dart';

@riverpod
class PRecipeEditorItemCategories extends _$PRecipeEditorItemCategories {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<List<CategoryDto>> build(String draftId) async {
    return await ref.watch(
      _parentProvider.selectAsync((data) => data.categories),
    );
  }

  Future<void> setCategories(List<CategoryDto> categories) async {
    final ids = categories.map((c) => c.id).toList();

    await ref.read(_parentProvider.notifier).setForm({
      'categories': ids,
    });
  }
}
