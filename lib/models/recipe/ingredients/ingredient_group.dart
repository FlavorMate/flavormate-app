import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe/ingredients/ingredient.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_group_draft.dart';

part 'ingredient_group.mapper.dart';

@MappableClass()
class IngredientGroup with IngredientGroupMappable {
  String? label;
  List<Ingredient> ingredients;

  IngredientGroup({this.label, required this.ingredients});

  IngredientGroupDraft toDraft() {
    return IngredientGroupDraft(
      label: label,
      ingredients: ingredients.map((i) => i.toDraft()).toList(),
    );
  }
}
