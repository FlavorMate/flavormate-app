import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_ref.dart';

part 'unit_conversion.mapper.dart';

@MappableClass()
class UnitConversion with UnitConversionMappable {
  final UnitConversionId id;
  final double factor;

  UnitConversion({
    required this.id,
    required this.factor,
  });
}

@MappableClass()
class UnitConversionId with UnitConversionIdMappable {
  final UnitRef from;
  final UnitRef to;

  UnitConversionId({required this.from, required this.to});
}
