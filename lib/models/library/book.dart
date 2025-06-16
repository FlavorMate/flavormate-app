import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'book.mapper.dart';

@MappableClass()
class Book extends Entity with BookMappable {
  final String label;
  final bool visible;
  final List<Recipe>? recipes;
  final Author owner;

  Book({
    required this.owner,
    required this.label,
    required this.visible,
    required this.recipes,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });

  bool has(Recipe recipe) {
    return recipes!.indexWhere((r) => r.id == recipe.id) >= 0;
  }
}
