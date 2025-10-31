import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flutter/material.dart';

part 'tag_dto.mapper.dart';

@immutable
@MappableClass()
class TagDto with TagDtoMappable {
  final String id;
  final String label;
  final int recipeCount;
  final RecipeFileDto? cover;

  const TagDto({
    required this.id,
    required this.label,
    required this.recipeCount,
    required this.cover,
  });
}
