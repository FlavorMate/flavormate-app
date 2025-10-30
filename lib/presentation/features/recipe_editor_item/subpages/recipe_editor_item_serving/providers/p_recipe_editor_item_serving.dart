import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_double.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_serving_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_serving.g.dart';

@riverpod
class PRecipeEditorItemServing extends _$PRecipeEditorItemServing {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<RecipeDraftServingDto> build(String draftId) async {
    return ref.watch(
      _parentProvider.selectAsync((data) => data.serving),
    );
  }

  Future<void> setAmount(String input) async {
    final amount = UDouble.tryParsePositive(input);

    await ref.read(_parentProvider.notifier).setForm({
      'serving': {'amount': amount},
    });
  }

  Future<void> setLabel(String input) async {
    final label = input.trimToNull;

    await ref.read(_parentProvider.notifier).setForm({
      'serving': {'label': label},
    });
  }
}
