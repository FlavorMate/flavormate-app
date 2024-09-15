import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/instructions/instruction.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';

part 'instruction_group.mapper.dart';

@MappableClass()
class InstructionGroup extends Entity with InstructionGroupMappable {
  String? label;
  List<Instruction> instructions;

  InstructionGroup({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.instructions,
    this.label,
  });

  InstructionGroupDraft toDraft() {
    return InstructionGroupDraft(
      label: label,
      instructions: instructions.map((i) => i.toDraft()).toList(),
    );
  }
}
