import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_diet.g.dart';

@riverpod
class PRecipeEditorItemDiet extends _$PRecipeEditorItemDiet {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<Diet?> build(String draftId) async {
    return await ref.watch(_parentProvider.selectAsync((it) => it.diet));
  }

  Future<void> set(Diet input) async {
    return await ref.read(_parentProvider.notifier).setDiet(input);
  }
}
