import 'package:dart_mappable/dart_mappable.dart';

part 'file_draft.mapper.dart';

@MappableClass()
class FileDraft with FileDraftMappable {
  final int id;
  final String type;
  final String category;
  final int owner;
  final String name;
  final String? content;

  FileDraft({
    required this.id,
    required this.type,
    required this.category,
    required this.owner,
    required this.name,
    required this.content,
  });
}
