import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';
import 'package:flavormate/models/recipe_draft/instructions/instruction_group_draft.dart';
import 'package:flavormate/models/recipe_draft/serving_draft/serving_draft.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';

part 'recipe_draft.mapper.dart';

@MappableClass()
class RecipeDraft with RecipeDraftMappable {
  List<int> categories;
  List<IngredientGroupDraft> ingredientGroups;
  List<InstructionGroupDraft> instructionGroups;
  ServingDraft serving;
  List<TagDraft> tags;
  Duration cookTime;
  Duration prepTime;
  Duration restTime;
  Course? course;
  Diet? diet;
  String? description;
  String? label;
  String? url;
  List<int>? files;

  RecipeDraft({
    required this.categories,
    required this.ingredientGroups,
    required this.instructionGroups,
    required this.serving,
    required this.tags,
    required this.cookTime,
    required this.prepTime,
    required this.restTime,
    this.course,
    this.diet,
    this.description,
    this.label,
    this.url,
    this.files,
  });

  factory RecipeDraft.empty() {
    return RecipeDraft(
      categories: [],
      ingredientGroups: [],
      instructionGroups: [],
      serving: ServingDraft(0, ''),
      tags: [],
      cookTime: Duration.zero,
      prepTime: Duration.zero,
      restTime: Duration.zero,
    );
  }

  double get commonProgress {
    var score = 0.0;
    if (label != null && label!.isNotEmpty) score += 100;
    if (description != null && description!.isNotEmpty) score += 50;
    return score;
  }

  double get servingProgress {
    var score = 0.0;
    if (serving.amount > 0) score += 50;
    if (serving.label.isNotEmpty) score += 50;
    return score;
  }

  double get durationProgress {
    var score = 0.0;
    if (prepTime.inMinutes + cookTime.inMinutes + restTime.inMinutes > 0) {
      score += 100;
    }
    return score;
  }

  double get ingredientsProgress {
    var score = 0.0;
    for (final group in ingredientGroups) {
      if (group.isValid) {
        score += 100 / ingredientGroups.length;
      }
    }
    return score;
  }

  double get instructionsProgress {
    var score = 0.0;
    for (final group in instructionGroups) {
      if (group.isValid) {
        score += 100 / instructionGroups.length;
      }
    }
    return score;
  }

  double get courseProgress {
    var score = 0.0;
    if (course != null) score += 100;

    return score;
  }

  double get dietProgress {
    var score = 0.0;
    if (diet != null) score += 100;

    return score;
  }

  double get tagsProgress {
    var score = 0.0;
    if (tags.isNotEmpty) score += 100;

    return score;
  }

  double get categoriesProgress {
    var score = 0.0;
    if (categories.isNotEmpty) score += 100;

    return score;
  }
}
