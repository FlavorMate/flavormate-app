import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';

part 'unit_ref.mapper.dart';

@MappableClass()
class UnitRef extends Entity with UnitRefMappable {
  static final _convertable = [
    // fluids
    'teaspoon',
    'tablespoon',
    'smooth tablespoon',
    'heaped tablespoon',
    'level teaspoon',
    'heaped teaspoon',
    'cup',
    'pint',
    'quart',
    'gallon',
    'centiliter',
    'deciliter',
    'milliliter',
    'liter',
    // weights
    'ounce',
    'pound',
    'gram',
    'kilogram',
    'milligram',
  ];

  final String description;

  UnitRef({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.description,
  });

  double? convertTo(UnitRef to) {
    return null;
  }

  bool isConvertable() {
    return _convertable.contains(description);
  }
}
