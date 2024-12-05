import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';

part 'file.mapper.dart';

@MappableClass()
class File extends Entity with FileMappable {
  final String type;
  final String category;
  final String? content;
  final String? fullPath;

  int owner;

  File({
    required this.type,
    required this.category,
    required this.owner,
    super.id,
    super.version,
    super.createdOn,
    super.lastModifiedOn,
    this.content,
    this.fullPath,
  });

  String get typePath {
    switch (type) {
      case 'IMAGE':
        return 'images';
      case _:
        return '';
    }
  }

  String get categoryPath {
    switch (category) {
      case 'ACCOUNT':
        return 'accounts';
      case 'AUTHOR':
        return 'authors';
      case 'RECIPE':
        return 'recipes';
      case _:
        return '';
    }
  }

  String get name {
    switch (type) {
      case 'IMAGE':
        return '$id.jpg';
      case _:
        return '';
    }
  }

  String path(String server) {
    return '$server/$categoryPath/${owner.toInt()}/$typePath/$name';
  }
}
