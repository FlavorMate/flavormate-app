import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_durations.g.dart';

@riverpod
class PRecipeEditorItemDurations extends _$PRecipeEditorItemDurations {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<RecipeDraftFullDto> build(String draftId) async {
    return ref.watch(_parentProvider.future);
  }

  Future<void> setPrepTime(Duration duration) async {
    return await ref.read(_parentProvider.notifier).setForm({
      'prepTime': duration.iso8601,
    });
  }

  Future<void> setCookTime(Duration duration) async {
    return await ref.read(_parentProvider.notifier).setForm({
      'cookTime': duration.iso8601,
    });
  }

  Future<void> setRestTime(Duration duration) async {
    return await ref.read(_parentProvider.notifier).setForm({
      'restTime': duration.iso8601,
    });
  }
}
