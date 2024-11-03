import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/recipe.dart';

part 'story.mapper.dart';

@MappableClass()
class Story extends Entity with StoryMappable {
  final Author author;

  final Recipe recipe;

  final String content;

  final String label;

  Story({
    required this.author,
    required this.recipe,
    required this.content,
    required this.label,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });
}
