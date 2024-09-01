import 'package:flavormate/models/entity.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'instruction.mapper.dart';

@MappableClass()
class Instruction extends Entity with InstructionMappable {
  String label;

  Instruction({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.label,
  });
}
