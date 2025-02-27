import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/categories/category_group.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/recipe.dart';

part 'category.mapper.dart';

@MappableClass()
class Category extends Entity with CategoryMappable {
  String label;
  CategoryGroup group;
  List<Recipe>? recipes;

  Category({
    required this.label,
    required this.group,
    required this.recipes,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });

  String? get coverUrl =>
      recipes
          ?.where((recipe) => EString.isNotEmpty(recipe.coverUrl))
          .firstOrNull
          ?.coverUrl;
}
