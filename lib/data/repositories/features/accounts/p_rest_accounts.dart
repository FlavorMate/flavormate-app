import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_accounts.g.dart';

@riverpod
class PRestAccounts extends _$PRestAccounts {
  @override
  Future<PageableDto<AccountPreviewDto>> build(
    String pageId, {
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageId));

    final client = AccountControllerApi(dio);

    final response = await client.getAccounts(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }
}
