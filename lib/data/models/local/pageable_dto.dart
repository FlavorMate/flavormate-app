import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:flavormate/data/models/features/category_drafts/category_group_dto.dart';
import 'package:flavormate/data/models/features/highlights/highlight_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_file_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/features/recipes/recipe_file_dto.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/features/story_drafts/story_draft_dto.dart';
import 'package:flavormate/data/models/features/tags/tag_dto.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flutter/material.dart';

part 'pageable_dto.mapper.dart';

@immutable
@MappableClass()
class PageableDto<T> with PageableDtoMappable<T> {
  final Metadata metadata;

  final List<T> data;

  const PageableDto({required this.metadata, required this.data});

  static PageableDto<T> fromAPI<T>(dynamic wrapper, Type clazz) {
    final metadata = MetadataMapper.fromMap(wrapper['metadata']);

    final mapper = switch (T) {
      const (AccountPreviewDto) => AccountPreviewDtoMapper.fromMap,
      const (AccountFullDto) => AccountFullDtoMapper.fromMap,
      const (BookDto) => BookDtoMapper.fromMap,
      const (CategoryDto) => CategoryDtoMapper.fromMap,
      const (CategoryGroupDto) => CategoryGroupDtoMapper.fromMap,
      const (HighlightDto) => HighlightDtoMapper.fromMap,
      const (RecipePreviewDto) => RecipePreviewDtoMapper.fromMap,
      const (RecipeFileDto) => RecipeFileDtoMapper.fromMap,
      const (RecipeDraftPreviewDto) => RecipeDraftPreviewDtoMapper.fromMap,
      const (RecipeDraftFileDto) => RecipeDraftFileDtoMapper.fromMap,
      const (StoryPreviewDto) => StoryPreviewDtoMapper.fromMap,
      const (StoryDraftPreviewDto) => StoryDraftPreviewDtoMapper.fromMap,
      const (TagDto) => TagDtoMapper.fromMap,
      const (UnitLocalizedDto) => UnitLocalizedDtoMapper.fromMap,
      _ => throw Exception('Unsupported mapper!'),
    };

    final data = List<Map<String, dynamic>>.from(wrapper['data']);

    return PageableDto(
      metadata: metadata,
      data: List<T>.from(data.map(mapper)),
    );
  }
}

@immutable
@MappableClass()
class Metadata with MetadataMappable {
  final int totalElements;
  final int pageSize;
  final int currentPage;
  final int totalPages;

  const Metadata({
    required this.totalElements,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
  });
}
