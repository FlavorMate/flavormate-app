import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_common.g.dart';

@riverpod
class PRecipeEditorItemCommon extends _$PRecipeEditorItemCommon {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<RecipeDraftFullDto> build(String draftId) async {
    return await ref.watch(_parentProvider.future);
  }

  Future<void> setLabel(String input) async {
    final label = input.trimToNull;

    return await ref.read(_parentProvider.notifier).setForm({'label': label});
  }

  Future<void> setDescription(String input) async {
    final description = input.trimToNull;

    return await ref.read(_parentProvider.notifier).setForm({
      'description': description,
    });
  }
}
