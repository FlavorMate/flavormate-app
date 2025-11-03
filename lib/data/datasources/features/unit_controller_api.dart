import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flutter/foundation.dart';

@immutable
class UnitControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureUnits;

  const UnitControllerApi(super.dio);

  Future<PageableDto<UnitLocalizedDto>> getUnits({
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
      mapper: (data) => PageableDto.fromAPI<UnitLocalizedDto>(
        data,
        UnitLocalizedDto,
      ),
    );

    return response.data!;
  }
}
