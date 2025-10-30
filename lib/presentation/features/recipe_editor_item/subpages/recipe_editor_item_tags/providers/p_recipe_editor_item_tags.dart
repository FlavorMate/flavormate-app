import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_tags.g.dart';

@riverpod
class PRecipeEditorItemTags extends _$PRecipeEditorItemTags {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<List<String>> build(String draftId) async {
    return ref.watch(_parentProvider.selectAsync((data) => data.tags));
  }

  Future<void> addTag(String label) async {
    if (state.value!.any((tag) => tag == label)) return;

    final list = state.value!.toList();
    list.add(label);

    ref.read(_parentProvider.notifier).setForm({'tags': list});
  }

  Future<void> deleteTag(String draft) async {
    final list = state.value!.toList();

    list.remove(draft);

    ref.read(_parentProvider.notifier).setForm({'tags': list});
  }
}
