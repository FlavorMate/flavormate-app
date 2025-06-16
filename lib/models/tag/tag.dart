import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/models/tag_draft/tag_draft.dart';

part 'tag.mapper.dart';

@MappableClass()
class Tag extends Entity with TagMappable {
  final String label;

  final List<Recipe>? recipes;

  Tag({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.label,
    required this.recipes,
  });

  String? get coverUrl => recipes
      ?.where((recipe) => EString.isNotEmpty(recipe.coverUrl))
      .firstOrNull
      ?.coverUrl;

  TagDraft toDraft() {
    return TagDraft(label: label);
  }
}
