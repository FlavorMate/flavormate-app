import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/drift/app_database.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/recipe/recipe.dart';

part 'story_draft.mapper.dart';

@MappableClass()
class StoryDraft with StoryDraftMappable {
  final int id;

  final int? originId;

  Recipe? recipe;

  String? content;

  String? label;

  final int version;

  StoryDraft({
    required this.id,
    required this.originId,
    required this.recipe,
    required this.content,
    required this.label,
    required this.version,
  });

  factory StoryDraft.fromDB(StoryDraftTableData data) {
    return StoryDraft(
      id: data.id,
      originId: data.originId,
      recipe: data.recipe,
      content: data.content,
      label: data.label,
      version: data.version,
    );
  }

  Map<String, dynamic> toBackend() {
    final map = toMap();
    map['id'] = originId;
    map.remove('originId');
    return map;
  }

  bool get isValid {
    return recipe != null &&
        EString.isNotEmpty(content) &&
        EString.isNotEmpty(label);
  }
}
