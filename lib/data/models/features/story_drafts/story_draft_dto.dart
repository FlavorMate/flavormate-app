import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flutter/material.dart';

part 'story_draft_dto.mapper.dart';

@immutable
@MappableClass()
abstract class StoryDraftDto with StoryDraftDtoMappable {
  final String id;
  final String? label;
  final RecipeFileDto? cover;
  final RecipePreviewDto? recipe;
  final String? originId;

  const StoryDraftDto({
    required this.id,
    required this.label,
    required this.cover,
    required this.recipe,
    required this.originId,
  });

  bool get isNew => originId == null;
}

@immutable
@MappableClass()
class StoryDraftPreviewDto extends StoryDraftDto
    with StoryDraftPreviewDtoMappable {
  const StoryDraftPreviewDto({
    required super.id,
    required super.label,
    required super.cover,
    required super.recipe,
    required super.originId,
  });
}

@immutable
@MappableClass()
class StoryDraftFullDto extends StoryDraftDto with StoryDraftFullDtoMappable {
  final String? content;
  final AccountPreviewDto ownedBy;

  const StoryDraftFullDto({
    required super.id,
    required super.label,
    required super.cover,
    required super.recipe,
    required super.originId,
    required this.content,
    required this.ownedBy,
  });
}
