import 'package:flavormate/models/entity.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'category_group.mapper.dart';

@MappableClass()
class CategoryGroup extends Entity with CategoryGroupMappable {
  final String label;

  CategoryGroup({
    required this.label,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });
}
