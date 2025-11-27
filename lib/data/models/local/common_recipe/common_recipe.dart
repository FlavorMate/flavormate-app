import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/core/utils/u_duration.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/common_recipe/common_category.dart';
import 'package:flavormate/data/models/local/common_recipe/common_file.dart';
import 'package:flavormate/data/models/local/common_recipe/common_ingredient_group.dart';
import 'package:flavormate/data/models/local/common_recipe/common_instruction_group.dart';
import 'package:flavormate/data/models/local/common_recipe/common_serving.dart';
import 'package:flavormate/data/models/local/common_recipe/common_tag.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';

part 'common_recipe.mapper.dart';

@MappableClass()
class CommonRecipe with CommonRecipeMappable {
  final String id;
  final AccountDto ownedBy;
  final String label;
  final String? description;
  final Duration prepTime;
  final Duration cookTime;
  final Duration restTime;
  final CommonServing serving;
  final List<CommonInstructionGroup> instructionGroups;
  final List<CommonIngredientGroup> ingredientGroups;
  final Course course;
  final Diet diet;
  final String? url;
  final List<CommonCategory> categories;
  final CommonFile? cover;
  final List<CommonFile> files;
  final List<CommonTag> tags;
  final DateTime createdOn;
  final int version;

  const CommonRecipe(
    this.id,
    this.ownedBy,
    this.label,
    this.description,
    this.prepTime,
    this.cookTime,
    this.restTime,
    this.serving,
    this.instructionGroups,
    this.ingredientGroups,
    this.course,
    this.diet,
    this.url,
    this.categories,
    this.cover,
    this.files,
    this.tags,
    this.createdOn,
    this.version,
  );

  bool get hasCover => cover != null;

  Duration get totalTime =>
      UDuration.addDurations([prepTime, cookTime, restTime]);

  factory CommonRecipe.fromDraft(RecipeDraftFullDto draft) {
    return CommonRecipe(
      draft.id,
      draft.ownedBy,
      draft.label!,
      draft.description,
      draft.prepTime,
      draft.cookTime,
      draft.restTime,
      CommonServing.fromDraft(draft.serving),
      draft.instructionGroups.map(CommonInstructionGroup.fromDraft).toList(),
      draft.ingredientGroups.map(CommonIngredientGroup.fromDraft).toList(),
      draft.course!,
      draft.diet!,
      draft.url,
      draft.categories.map(CommonCategory.fromDraft).toList(),
      null,
      draft.files.map(CommonFile.fromDraft).toList(),
      draft.tags.map(CommonTag.fromDraft).toList(),
      DateTime.now(),
      0,
    );
  }

  factory CommonRecipe.fromRecipe(RecipeFullDto recipe) {
    return CommonRecipe(
      recipe.id,
      recipe.ownedBy,
      recipe.label,
      recipe.description,
      recipe.prepTime,
      recipe.cookTime,
      recipe.restTime,
      CommonServing.fromRecipe(recipe.serving),
      recipe.instructionGroups.map(CommonInstructionGroup.fromRecipe).toList(),
      recipe.ingredientGroups.map(CommonIngredientGroup.fromRecipe).toList(),
      recipe.course,
      recipe.diet,
      recipe.url,
      recipe.categories.map(CommonCategory.fromRecipe).toList(),
      recipe.cover?.let(CommonFile.fromRecipe),
      recipe.files.map(CommonFile.fromRecipe).toList(),
      recipe.tags.map(CommonTag.fromRecipe).toList(),
      recipe.createdOn,
      recipe.version,
    );
  }
}
