import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/datasources/features/admin_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/account_create_form.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_admin_accounts.g.dart';

@riverpod
class PRestAdminAccounts extends _$PRestAdminAccounts {
  @override
  Future<PageableDto<AccountFullDto>> build({
    required String pageProviderId,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final page = ref.watch(pPageableStateProvider(pageProviderId));

    final client = AdminControllerApi(dio);

    final response = await client.getAdminAccounts(
      page: page,
      pageSize: pageSize,
      orderBy: orderBy,
      orderDirection: orderDirection,
    );

    return response;
  }

  Future<ApiResponse<void>> createAccount(AccountCreateForm form) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AdminControllerApi(dio);

    final response = await client.createAccount(form: form);

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> setPassword(
    String accountId,
    String newPassword,
  ) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AdminControllerApi(dio);

    final response = await client.setAccountPassword(
      id: accountId,
      newPassword: newPassword,
    );

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> toggleActiveState(String accountId) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AdminControllerApi(dio);

    final response = await client.toggleActiveState(id: accountId);

    ref.invalidateSelf();

    return response;
  }

  Future<ApiResponse<void>> deleteAccount(String accountId) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = AdminControllerApi(dio);

    final response = await client.deleteAccount(id: accountId);

    ref.invalidateSelf();

    return response;
  }
}
