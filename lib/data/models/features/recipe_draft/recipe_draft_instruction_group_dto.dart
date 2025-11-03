import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

part 'recipe_draft_instruction_group_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeDraftInstructionGroupDto
    with RecipeDraftInstructionGroupDtoMappable {
  final String id;
  final int index;
  final List<RecipeDraftInstructionGroupItemDto> instructions;
  final String? label;

  const RecipeDraftInstructionGroupDto({
    required this.id,
    required this.index,
    required this.instructions,
    required this.label,
  });

  bool get isValid =>
      instructions.isNotEmpty && instructions.every((i) => i.isValid);

  double get validPercent {
    if (instructions.isEmpty) return 0;

    return instructions.where((instruction) => instruction.isValid).length /
        instructions.length;
  }

  factory RecipeDraftInstructionGroupDto.create({required int index}) {
    return RecipeDraftInstructionGroupDto(
      id: const Uuid().v4(),
      index: index,
      instructions: const [],
      label: null,
    );
  }
}

@immutable
@MappableClass()
class RecipeDraftInstructionGroupItemDto
    with RecipeDraftInstructionGroupItemDtoMappable {
  final String id;
  final int index;
  final String? label;

  const RecipeDraftInstructionGroupItemDto({
    required this.id,
    required this.label,
    required this.index,
  });

  bool get isValid => label?.isNotEmpty ?? false;

  double get validPercent => isValid ? 1 : 0;

  factory RecipeDraftInstructionGroupItemDto.create({required int index}) {
    return RecipeDraftInstructionGroupItemDto(
      id: const Uuid().v4(),
      index: index,
      label: null,
    );
  }
}
