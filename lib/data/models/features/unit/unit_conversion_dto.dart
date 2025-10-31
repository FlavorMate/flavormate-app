import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';

part 'unit_conversion_dto.mapper.dart';

@MappableClass()
class UnitConversionDto with UnitConversionDtoMappable {
  final UnitRefDto source;
  final UnitRefDto target;
  final double factor;

  const UnitConversionDto({
    required this.source,
    required this.target,
    required this.factor,
  });
}
