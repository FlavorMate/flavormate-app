import 'package:dart_mappable/dart_mappable.dart';

part 'entity.mapper.dart';

@MappableClass()
class Entity with EntityMappable {
  int? id;
  int? version;
  DateTime? createdOn;
  DateTime? lastModifiedOn;

  Entity({
    required this.id,
    required this.version,
    required this.createdOn,
    required this.lastModifiedOn,
  });
}
