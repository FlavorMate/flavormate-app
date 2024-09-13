import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';

part 'unit.mapper.dart';

@MappableClass()
class Unit extends Entity with UnitMappable {
  final String label;

  Unit({
    super.id,
    super.createdOn,
    super.lastModifiedOn,
    super.version,
    required this.label,
  });

  String get beautify {
    return label;
  }
}
