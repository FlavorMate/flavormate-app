import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/tag_controller_api.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_tags_id_recipes.g.dart';

@riverpod
class PRestTagsIdRecipes extends _$PRestTagsIdRecipes {
  @override
  Future<PageableDto<RecipePreviewDto>> build(
    String tagId,
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageId));

    final client = TagControllerApi(dio);

    final response = await client.getTagsIdRecipes(
      tagId: tagId,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
