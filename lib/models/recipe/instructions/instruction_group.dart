import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/instructions/instruction.dart';
import 'package:dart_mappable/dart_mappable.dart';

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
}
