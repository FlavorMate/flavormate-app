import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';

part 'scrape_response.mapper.dart';

@MappableClass()
class ScrapeResponse with ScrapeResponseMappable {
  final RecipeDraft recipe;
  final List<String> images;

  ScrapeResponse({required this.recipe, required this.images});
}
