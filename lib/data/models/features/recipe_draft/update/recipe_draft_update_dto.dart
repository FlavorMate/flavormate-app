import 'package:dart_mappable/dart_mappable.dart';

part 'recipe_draft_update_dto.mapper.dart';

@MappableClass(ignoreNull: true)
class RecipeDraftUpdateDto with RecipeDraftUpdateDtoMappable {
  final String? label;
  final String? description;

  RecipeDraftUpdateDto({this.label, this.description});
}
