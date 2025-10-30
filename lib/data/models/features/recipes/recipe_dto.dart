import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/utils/u_duration.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_instruction_group_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_serving_dto.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flutter/material.dart';

part 'recipe_dto.mapper.dart';

@immutable
@MappableClass()
abstract class RecipeDto with RecipeDtoMappable {
  final String id;
  final DateTime createdOn;
  final String label;
  final Diet diet;
  final Duration prepTime;
  final Duration cookTime;
  final Duration restTime;
  final RecipeFileDto? cover;

  const RecipeDto({
    required this.id,
    required this.createdOn,
    required this.label,
    required this.diet,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.cover,
  });

  bool get hasCover => cover != null;

  Duration get totalTime =>
      UDuration.addDurations([prepTime, cookTime, restTime]);
}

@immutable
@MappableClass()
class RecipePreviewDto extends RecipeDto with RecipePreviewDtoMappable {
  const RecipePreviewDto({
    required super.id,
    required super.createdOn,
    required super.label,
    required super.diet,
    required super.prepTime,
    required super.cookTime,
    required super.restTime,
    required super.cover,
  });
}

@immutable
@MappableClass()
class RecipeFullDto extends RecipeDto with RecipeFullDtoMappable {
  final int version;
  final AccountPreviewDto ownedBy;
  final String? description;
  final RecipeServingDto serving;
  final List<RecipeInstructionGroupDto> instructionGroups;
  final List<RecipeIngredientGroupDto> ingredientGroups;
  final Course course;
  final String? url;
  final List<CategoryDto> categories;
  final List<TagDto> tags;
  final List<RecipeFileDto> files;

  const RecipeFullDto({
    required super.id,
    required super.createdOn,
    required super.label,
    required super.diet,
    required super.prepTime,
    required super.cookTime,
    required super.restTime,
    required super.cover,
    required this.version,
    required this.ownedBy,
    required this.description,
    required this.serving,
    required this.instructionGroups,
    required this.ingredientGroups,
    required this.course,
    required this.url,
    required this.categories,
    required this.tags,
    required this.files,
  });
}
