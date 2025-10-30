import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_serving_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_serving_dto.dart';

part 'common_serving.mapper.dart';

@MappableClass()
class CommonServing with CommonServingMappable {
  final double amount;
  final String label;

  CommonServing({
    required this.amount,
    required this.label,
  });

  factory CommonServing.fromDraft(RecipeDraftServingDto draft) {
    return CommonServing(
      amount: draft.amount!,
      label: draft.label!,
    );
  }

  factory CommonServing.fromRecipe(RecipeServingDto recipe) {
    return CommonServing(
      amount: recipe.amount,
      label: recipe.label,
    );
  }
}
