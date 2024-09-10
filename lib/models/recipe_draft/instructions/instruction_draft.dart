import 'package:dart_mappable/dart_mappable.dart';

part 'instruction_draft.mapper.dart';

@MappableClass()
class InstructionDraft with InstructionDraftMappable {
  String label;

  InstructionDraft({required this.label});

  bool get isValid => label.isNotEmpty;
}
