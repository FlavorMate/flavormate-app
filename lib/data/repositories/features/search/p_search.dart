import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/delayed_provider/p_delayed_provider.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/search_controller_api.dart';
import 'package:flavormate/data/models/features/search/search_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search.g.dart';

@riverpod
class PSearch extends _$PSearch with DebounceProvider {
  @override
  Future<PageableDto<SearchDto>> build(
    String search, {
    required Set<SearchDtoSource> filter,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    if (search.isBlank) return PageableDto.empty();

    final page = ref.watch(pPageableStateProvider(PageableState.search.name));

    // Page 0 means user input, so debounce
    if (page == 0) {
      await debounce(ref);
    }

    final language = currentLanguage().name;

    final dio = ref.watch(pDioPrivateProvider);
    final client = SearchControllerApi(dio);

    return await client.search(
      searchTerm: search,
      language: language,
      filter: filter,
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );
  }
}
