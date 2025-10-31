import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flutter/material.dart';

part 'category_dto.mapper.dart';

@immutable
@MappableClass()
class CategoryDto with CategoryDtoMappable {
  final String id;
  final String label;
  final int recipeCount;
  final RecipeFileDto? cover;

  const CategoryDto({
    required this.id,
    required this.label,
    required this.recipeCount,
    required this.cover,
  });
}
