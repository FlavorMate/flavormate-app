import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/unit_controller_api.dart';
import 'package:flavormate/data/models/features/unit/unit_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_units.g.dart';

@riverpod
class PRestUnits extends _$PRestUnits {
  @override
  Future<PageableDto<UnitLocalizedDto>> build({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final language = currentLocalization().languageCode;

    final dio = ref.watch(pDioPrivateProvider);

    final client = UnitControllerApi(dio);

    final response = await client.getUnits(
      language: language,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    if (ref.mounted) ref.keepAlive();

    return response;
  }
}
