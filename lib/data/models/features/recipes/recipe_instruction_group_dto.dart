import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'recipe_instruction_group_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeInstructionGroupDto with RecipeInstructionGroupDtoMappable {
  final String id;
  final int index;
  final List<RecipeInstructionGroupItemDto> instructions;
  final String? label;

  const RecipeInstructionGroupDto({
    required this.id,
    required this.index,
    required this.instructions,
    required this.label,
  });
}

@immutable
@MappableClass()
class RecipeInstructionGroupItemDto with RecipeInstructionGroupItemDtoMappable {
  final String id;
  final String label;
  final int index;

  const RecipeInstructionGroupItemDto({
    required this.id,
    required this.label,
    required this.index,
  });
}
