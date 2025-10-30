import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/highlights/highlight_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/foundation.dart';

@immutable
class HighlightControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureHighlights;

  const HighlightControllerApi(super.dio);

  Future<PageableDto<HighlightDto>> getHighlights({
    required Diet diet,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/',
      queryParameters: {
        'diet': diet.name,
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<HighlightDto>(
        data,
        HighlightDto,
      ),
    );

    return response.data!;
  }
}
