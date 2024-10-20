import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';

part 'unit_ref.mapper.dart';

@MappableClass()
class UnitRef extends Entity with UnitRefMappable {
  final String description;

  UnitRef({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.description,
  });
}
