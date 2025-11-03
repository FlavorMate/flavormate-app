import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flutter/material.dart';

part 'book_dto.mapper.dart';

@immutable
@MappableClass()
class BookDto with BookDtoMappable {
  final String id;
  final int version;
  final DateTime createdOn;
  final DateTime lastModifiedOn;
  final AccountPreviewDto ownedBy;

  final String label;
  final bool visible;
  final RecipeFileDto? cover;
  final int recipeCount;
  final int subscriberCount;

  const BookDto({
    required this.id,
    required this.version,
    required this.createdOn,
    required this.lastModifiedOn,
    required this.ownedBy,
    required this.label,
    required this.visible,
    required this.cover,
    required this.recipeCount,
    required this.subscriberCount,
  });
}
