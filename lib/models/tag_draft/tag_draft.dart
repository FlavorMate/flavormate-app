import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe/recipe.dart';

part 'tag_draft.mapper.dart';

@MappableClass()
class TagDraft with TagDraftMappable {
  final String label;

  TagDraft({required this.label});
}
