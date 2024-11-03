import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/recipe/recipe.dart';

part 'story_draft.mapper.dart';

@MappableClass()
class StoryDraft with StoryDraftMappable {
  final int id;

  Recipe? recipe;

  String? content;

  String? label;

  final int version;

  StoryDraft({
    required this.id,
    required this.recipe,
    required this.content,
    required this.label,
    required this.version,
  });

  factory StoryDraft.fromDB(StoryDraftTableData data) {
    return StoryDraft(
      id: data.id,
      recipe: data.recipe,
      content: data.content,
      label: data.label,
      version: data.version,
    );
  }

  bool get isValid {
    return recipe != null &&
        EString.isNotEmpty(content) &&
        EString.isNotEmpty(label);
  }
}
