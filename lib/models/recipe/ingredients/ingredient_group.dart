import 'package:flavormate/models/recipe/ingredients/ingredient.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'ingredient_group.mapper.dart';

@MappableClass()
class IngredientGroup with IngredientGroupMappable {
  String? label;
  List<Ingredient> ingredients;

  IngredientGroup({this.label, required this.ingredients});
}
