import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/recipe/unit_ref/unit_ref.dart';

part 'unit_localized.mapper.dart';

@MappableClass()
class UnitLocalized extends Entity with UnitLocalizedMappable {
  final UnitRef unitRef;
  final String language;
  final String labelSg;
  final String? labelSgAbrv;
  final String? labelPl;
  final String? labelPlAbrv;

  UnitLocalized({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.unitRef,
    required this.language,
    required this.labelSg,
    required this.labelSgAbrv,
    required this.labelPl,
    required this.labelPlAbrv,
  });

  String getLabel(double? amount) {
    if (amount != 1.0) {
      if (!EString.isEmpty(labelPlAbrv)) {
        return labelPlAbrv!;
      } else if (!EString.isEmpty(labelPl)) {
        return labelPl!;
      }
    }
    if (!EString.isEmpty(labelSgAbrv)) {
      return labelSgAbrv!;
    } else {
      return labelSg;
    }
  }
}
