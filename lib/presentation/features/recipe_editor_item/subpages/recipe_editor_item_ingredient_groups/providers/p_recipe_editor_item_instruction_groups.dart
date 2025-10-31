import 'package:collection/collection.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'p_recipe_editor_item_instruction_groups.g.dart';

@riverpod
class PRecipeEditorItemIngredientGroups
    extends _$PRecipeEditorItemIngredientGroups {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<List<RecipeDraftIngredientGroupDto>> build(String draftId) async {
    final groups = await ref.watch(
      _parentProvider.selectAsync((data) => data.ingredientGroups),
    );

    return groups.sortedBy((v) => v.index);
  }

  Future<void> createGroup() async {
    final id = const Uuid().v4();
    final index = state.value!.length;

    final form = {
      'ingredientGroups': [
        {'id': id, 'index': index},
      ],
    };

    await ref.read(_parentProvider.notifier).setForm(form);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final newOrder = state.value!
        .sortedBy((it) => it.index)
        .swapItems(oldIndex, newIndex)
        .mapIndexed((index, item) => {'id': item.id, 'index': index})
        .toList();

    await ref.read(_parentProvider.notifier).setForm({
      'ingredientGroups': newOrder,
    });
  }

  Future<void> updateChild(Map<String, dynamic> childForm) async {
    await ref.read(_parentProvider.notifier).setForm({
      'ingredientGroups': [childForm],
    });
  }
}
