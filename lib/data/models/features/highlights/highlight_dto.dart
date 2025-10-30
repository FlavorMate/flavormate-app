import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flutter/material.dart';

part 'highlight_dto.mapper.dart';

@immutable
@MappableClass()
class HighlightDto with HighlightDtoMappable {
  final String id;
  final DateTime date;
  final Diet diet;
  final RecipePreviewDto recipe;
  final RecipeFileDto? cover;

  const HighlightDto({
    required this.id,
    required this.date,
    required this.diet,
    required this.recipe,
    required this.cover,
  });
}
