import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';

class PRecipePageWrapper {
  final CommonRecipe recipe;
  final bool isBringEnabled;
  final bool isShareEnabled;
  final bool isOwner;
  final bool isAdmin;

  PRecipePageWrapper({
    required this.recipe,
    required this.isBringEnabled,
    required this.isShareEnabled,
    required this.isOwner,
    required this.isAdmin,
  });
}
