import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe_draft/ingredients/ingredient_draft.dart';

part 'ingredient_group_draft.mapper.dart';

@MappableClass()
class IngredientGroupDraft with IngredientGroupDraftMappable {
  String? label;
  final List<IngredientDraft> ingredients;

  IngredientGroupDraft({this.label, required this.ingredients});

  bool get isValid =>
      ingredients.isNotEmpty && ingredients.every((i) => i.isValid);
}
