import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';

class SearchControllerApi extends ControllerApi {
  final _root = ApiConstants.FeatureSearch;

  const SearchControllerApi(super._dio);

  Future<PageableDto<SearchDto>> search({
    required String searchTerm,
    required String language,
    required Set<SearchDtoSource> filter,
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/$searchTerm',
      queryParameters: {
        'language': language,
        'filter': filter.map((it) => it.name).join(','),
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<SearchDto>(data, SearchDto),
    );

    return response.data!;
  }
}
