import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/presentation/features/recipe_editor_item/subpages/recipe_editor_item_instruction_groups_item/providers/p_recipe_editor_item_instruction_groups_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipe_editor_item_instruction_groups_item_instruction.g.dart';

@riverpod
class PRecipeEditorItemInstructionGroupsItemInstruction
    extends _$PRecipeEditorItemInstructionGroupsItemInstruction {
  PRecipeEditorItemInstructionGroupsItemProvider get _parentProvider =>
      pRecipeEditorItemInstructionGroupsItemProvider(
        draftId,
        instructionGroupId,
      );

  Map<String, dynamic> get _baseForm => {'id': instructionId};

  @override
  Future<RecipeDraftInstructionGroupItemDto> build(
    String draftId,
    String instructionGroupId,
    String instructionId,
  ) async {
    return ref.watch(
      _parentProvider.selectAsync(
        (group) => group.instructions
            .where((instruction) => instruction.id == instructionId)
            .first,
      ),
    );
  }

  Future<void> setLabel(String label) async {
    final form = _baseForm;

    form['label'] = label.trimToNull;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }

  Future<void> delete() async {
    final form = _baseForm;

    form['delete'] = true;

    await ref.read(_parentProvider.notifier).updateChild(form);
  }
}
