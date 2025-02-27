import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_draft.dart';

part 'instruction_group_draft.mapper.dart';

@MappableClass()
class InstructionGroupDraft with InstructionGroupDraftMappable {
  String? label;
  List<InstructionDraft> instructions;

  InstructionGroupDraft({this.label, required this.instructions});

  bool get isValid =>
      instructions.isNotEmpty && instructions.every((i) => i.isValid);
}
