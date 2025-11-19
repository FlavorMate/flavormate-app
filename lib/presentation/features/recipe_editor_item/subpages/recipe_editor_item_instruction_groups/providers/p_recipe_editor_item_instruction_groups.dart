import 'package:collection/collection.dart';
import 'package:flavormate/core/extensions/e_list.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'p_recipe_editor_item_instruction_groups.g.dart';

@riverpod
class PRecipeEditorItemInstructionGroups
    extends _$PRecipeEditorItemInstructionGroups {
  PRestRecipeDraftsIdProvider get _parentProvider =>
      pRestRecipeDraftsIdProvider(draftId);

  @override
  Future<List<RecipeDraftInstructionGroupDto>> build(String draftId) async {
    final groups = await ref.watch(
      _parentProvider.selectAsync((data) => data.instructionGroups),
    );

    return groups.sortedBy((v) => v.index);
  }

  Future<String> createGroup() async {
    final id = const Uuid().v4();
    final index = state.value!.length;

    final form = {
      'instructionGroups': [
        {'id': id, 'index': index},
      ],
    };

    await ref.read(_parentProvider.notifier).setForm(form);

    return id;
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
      'instructionGroups': [childForm],
    });
  }
}
