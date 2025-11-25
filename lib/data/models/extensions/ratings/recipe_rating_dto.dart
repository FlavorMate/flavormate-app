import 'package:dart_mappable/dart_mappable.dart';

part 'recipe_rating_dto.mapper.dart';

@MappableClass()
class RecipeRatingDto with RecipeRatingDtoMappable {
  final String recipeId;
  final int star1;
  final int star2;
  final int star3;
  final int star4;
  final int star5;
  final int total;
  final double average;
  final double? ownRating;

  const RecipeRatingDto(
    this.recipeId,
    this.star1,
    this.star2,
    this.star3,
    this.star4,
    this.star5,
    this.total,
    this.average,
    this.ownRating,
  );
}
