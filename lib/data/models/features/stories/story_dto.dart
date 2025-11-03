import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flutter/material.dart';

part 'story_dto.mapper.dart';

@immutable
@MappableClass()
abstract class StoryDto with StoryDtoMappable {
  final String id;
  final String label;
  final RecipeFileDto? cover;

  const StoryDto({required this.id, required this.label, required this.cover});
}

@MappableClass()
class StoryPreviewDto extends StoryDto with StoryPreviewDtoMappable {
  const StoryPreviewDto({
    required super.id,
    required super.label,
    required super.cover,
  });
}

@MappableClass()
class StoryFullDto extends StoryDto with StoryFullDtoMappable {
  final String content;
  final AccountPreviewDto ownedBy;
  final RecipePreviewDto recipe;

  const StoryFullDto({
    required super.id,
    required super.label,
    required super.cover,
    required this.content,
    required this.ownedBy,
    required this.recipe,
  });
}
