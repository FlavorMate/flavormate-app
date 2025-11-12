import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/utils/u_duration.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_ingredient_group_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_instruction_group_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_serving_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flutter/material.dart';

part 'recipe_draft_dto.mapper.dart';

@immutable
@MappableClass()
abstract class RecipeDraftDto with RecipeDraftDtoMappable {
  final String id;
  final int version;
  final DateTime createdOn;
  final DateTime lastModifiedOn;
  final String? label;
  final String? originId;

  const RecipeDraftDto({
    required this.id,
    required this.version,
    required this.createdOn,
    required this.lastModifiedOn,
    required this.label,
    required this.originId,
  });

  bool get isNew => originId == null;
}

@immutable
@MappableClass()
class RecipeDraftPreviewDto extends RecipeDraftDto
    with RecipeDraftPreviewDtoMappable {
  const RecipeDraftPreviewDto({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required super.label,
    required super.originId,
  });
}

@immutable
@MappableClass()
class RecipeDraftFullDto extends RecipeDraftDto
    with RecipeDraftFullDtoMappable {
  final AccountPreviewDto ownedBy;
  final String? description;
  final Duration prepTime;
  final Duration cookTime;
  final Duration restTime;
  final RecipeDraftServingDto serving;
  final List<RecipeDraftIngredientGroupDto> ingredientGroups;
  final List<RecipeDraftInstructionGroupDto> instructionGroups;
  final List<CategoryDto> categories;
  final List<String> tags;
  final Course? course;
  final Diet? diet;
  final String? url;
  final List<RecipeDraftFileDto> files;

  const RecipeDraftFullDto({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required super.label,
    required super.originId,
    required this.ownedBy,
    required this.description,
    required this.prepTime,
    required this.cookTime,
    required this.restTime,
    required this.serving,
    required this.ingredientGroups,
    required this.instructionGroups,
    required this.categories,
    required this.tags,
    required this.course,
    required this.diet,
    required this.url,
    required this.files,
  });

  double get commonProgress {
    var score = 0.0;
    if (EString.isNotEmpty(label)) score += 1;
    if (EString.isNotEmpty(description)) score += 0.5;
    return score;
  }

  double get servingProgress => serving.validPercent;

  double get durationProgress =>
      UDuration.addDurations([prepTime, cookTime, restTime]).inSeconds > 0
      ? 1
      : 0;

  double get ingredientsProgress {
    if (ingredientGroups.isEmpty) return 0;

    return ingredientGroups.where((group) => group.isValid).length /
        ingredientGroups.length;
  }

  double get instructionsProgress {
    if (instructionGroups.isEmpty) return 0;
    return instructionGroups.where((group) => group.isValid).length /
        instructionGroups.length;
  }

  double get courseProgress => course != null ? 1 : 0;

  double get dietProgress => diet != null ? 1 : 0;

  double get tagsProgress => tags.isNotEmpty ? 1 : 0;

  double get categoriesProgress => categories.isNotEmpty ? 1 : 0;

  double get imageProgress => files.isEmpty ? 0 : 1;

  double get originProgress => (url?.isEmpty ?? true) ? 0 : 1;

  bool get isValid =>
      commonProgress >= 1 &&
      servingProgress >= 1 &&
      durationProgress >= 1 &&
      ingredientsProgress >= 1 &&
      instructionsProgress >= 1 &&
      courseProgress >= 1 &&
      dietProgress >= 1;
}
