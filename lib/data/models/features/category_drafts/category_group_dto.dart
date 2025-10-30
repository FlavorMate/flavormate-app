import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flutter/material.dart';

part 'category_group_dto.mapper.dart';

@immutable
@MappableClass()
class CategoryGroupDto with CategoryGroupDtoMappable {
  final String id;
  final String label;
  final List<CategoryDto> categories;

  const CategoryGroupDto({
    required this.id,
    required this.label,
    required this.categories,
  });
}
