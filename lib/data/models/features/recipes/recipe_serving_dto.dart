import 'package:dart_mappable/dart_mappable.dart';
import 'package:material_ui/material_ui.dart';

part 'recipe_serving_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeServingDto with RecipeServingDtoMappable {
  final String id;
  final double amount;
  final String label;

  const RecipeServingDto({
    required this.id,
    required this.amount,
    required this.label,
  });
}
