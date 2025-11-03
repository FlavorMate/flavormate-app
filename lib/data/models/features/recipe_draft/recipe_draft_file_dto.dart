import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/shared/enums/image_resolution.dart';
import 'package:flutter/material.dart';

part 'recipe_draft_file_dto.mapper.dart';

@immutable
@MappableClass()
class RecipeDraftFileDto with RecipeDraftFileDtoMappable {
  final String id;
  final String path;

  const RecipeDraftFileDto({required this.id, required this.path});

  String url(ImageWideResolution resolution) =>
      '$path?resolution=${resolution.name}';
}
