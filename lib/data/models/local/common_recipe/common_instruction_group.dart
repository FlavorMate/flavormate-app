import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_instruction_group_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction.dart';

part 'common_instruction_group.mapper.dart';

@MappableClass()
class CommonInstructionGroup with CommonInstructionGroupMappable {
  final String id;
  final String? label;
  final int index;
  final List<CommonInstruction> instructions;

  const CommonInstructionGroup({
    required this.id,
    required this.label,
    required this.index,
    required this.instructions,
  });

  factory CommonInstructionGroup.fromDraft(
    RecipeDraftInstructionGroupDto draft,
  ) {
    return CommonInstructionGroup(
      id: draft.id,
      label: draft.label,
      index: draft.index,
      instructions: draft.instructions
          .map(CommonInstruction.fromDraft)
          .toList(),
    );
  }

  factory CommonInstructionGroup.fromRecipe(RecipeInstructionGroupDto recipe) {
    return CommonInstructionGroup(
      id: recipe.id,
      label: recipe.label,
      index: recipe.index,
      instructions: recipe.instructions
          .map(CommonInstruction.fromRecipe)
          .toList(),
    );
  }
}
