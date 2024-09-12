import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/recipe_draft/recipe_draft.dart';

part 'scrape_response.mapper.dart';

@MappableClass()
class ScrapeResponse with ScrapeResponseMappable {
  final RecipeDraft recipe;
  final String image;

  ScrapeResponse({required this.recipe, required this.image});
}
