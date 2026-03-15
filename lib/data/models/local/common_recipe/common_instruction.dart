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

  String format(double amountFactor) {
    var value = label;

    int lIndex = -1;
    int rIndex = -1;
    do {
      lIndex = value.indexOf('[[', lIndex + 1);
      rIndex = value.indexOf(']]', rIndex + 1);

      if (lIndex != -1) {
        var foundText = value.substring(lIndex + 2, rIndex);
        double newValue = double.tryParse(foundText) ?? 1;
        newValue = newValue * (amountFactor);
        value = value.replaceAll(
          '[[$foundText]]',
          newValue % 1 == 0
              ? newValue.toStringAsFixed(0)
              : newValue.toStringAsFixed(2),
        );
      }
    } while (lIndex != -1);
    return value;
  }
}
