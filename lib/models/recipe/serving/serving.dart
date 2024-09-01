import 'package:flavormate/models/entity.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'serving.mapper.dart';

@MappableClass()
class Serving extends Entity with ServingMappable {
  String label;
  double amount;

  Serving({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.label,
    required this.amount,
  });
}
