import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_instruction_group_dto.dart';

part 'common_instruction.mapper.dart';

@MappableClass()
class CommonInstruction with CommonInstructionMappable {
  final String id;
  final String label;
  final int index;

  const CommonInstruction({
    required this.id,
    required this.label,
    required this.index,
  });

  factory CommonInstruction.fromDraft(
    RecipeDraftInstructionGroupItemDto draft,
  ) {
    return CommonInstruction(
      id: draft.id,
      index: draft.index,
      label: draft.label!,
    );
  }

  factory CommonInstruction.fromRecipe(RecipeInstructionGroupItemDto recipe) {
    return CommonInstruction(
      id: recipe.id,
      label: recipe.label,
      index: recipe.index,
    );
  }
}
