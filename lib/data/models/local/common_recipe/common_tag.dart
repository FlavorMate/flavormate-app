import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:uuid/uuid.dart';

part 'common_tag.mapper.dart';

@MappableClass()
class CommonTag with CommonTagMappable {
  final String id;
  final String label;

  const CommonTag({
    required this.id,
    required this.label,
  });

  factory CommonTag.fromDraft(String draft) {
    return CommonTag(
      id: const Uuid().v4(),
      label: draft,
    );
  }

  factory CommonTag.fromRecipe(TagDto recipe) {
    return CommonTag(
      id: recipe.id,
      label: recipe.label,
    );
  }
}
