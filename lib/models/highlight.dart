import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'highlight.mapper.dart';

@MappableClass()
class Highlight extends Entity with HighlightMappable {
  final Recipe recipe;

  final DateTime date;

  final Diet diet;

  Highlight({
    required this.recipe,
    required this.date,
    required this.diet,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });
}
