import 'package:dart_mappable/dart_mappable.dart';

part 'tag_draft.mapper.dart';

@MappableClass()
class TagDraft with TagDraftMappable {
  final String label;

  TagDraft({required this.label});
}
