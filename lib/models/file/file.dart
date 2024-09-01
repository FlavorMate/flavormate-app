import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';

part 'file.mapper.dart';

@MappableClass()
class File extends Entity with FileMappable {
  final String type;
  final String category;
  final double owner;

  File({
    required this.type,
    required this.category,
    required this.owner,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
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
