import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/category_drafts/category_group_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/foundation.dart';

@immutable
class CategoryGroupControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureCategoryGroups;

  const CategoryGroupControllerApi(super.dio);

  Future<PageableDto<CategoryGroupDto>> getCategoryGroups({
    required String language,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/',
      queryParameters: {
        'language': language,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<CategoryGroupDto>(
        data,
        CategoryGroupDto,
      ),
    );

    return response.data!;
  }
}
