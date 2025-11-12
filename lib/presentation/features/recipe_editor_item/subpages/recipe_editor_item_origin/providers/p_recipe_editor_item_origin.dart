import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_origin.g.dart';

@riverpod
class PRecipeEditorItemOrigin extends _$PRecipeEditorItemOrigin {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<String?> build(String draftId) async {
    return ref.watch(_parentProvider.selectAsync((data) => data.url));
  }

  Future<void> set(String value) async {
    return await ref.read(_parentProvider.notifier).setForm({
      'url': value.trimToNull,
    });
  }
}
