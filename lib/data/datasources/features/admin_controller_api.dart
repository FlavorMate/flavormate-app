import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/account_create_form.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';

@immutable
class AdminControllerApi extends ControllerApi {
  static const _root = ApiConstants.FeatureAdmin;

  const AdminControllerApi(super.dio);

  Future<PageableDto<AccountFullDto>> getAdminAccounts({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/accounts',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<AccountFullDto>(
        data,
        AccountFullDto,
      ),
    );

    return response.data!;
  }

  Future<ApiResponse<void>> deleteAccount({required String id}) async {
    return delete(url: '$_root/account/$id', mapper: ControllerApi.nullMapper);
  }

  Future<ApiResponse<void>> setAccountPassword({
    required String id,
    required String newPassword,
  }) async {
    return put(
      url: '$_root/account/$id',
      data: newPassword,
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> createAccount({
    required AccountCreateForm form,
  }) async {
    return post(
      url: '$_root/account',
      data: form.toJson(),
      mapper: ControllerApi.nullMapper,
    );
  }

  Future<ApiResponse<void>> toggleActiveState({required String id}) async {
    return await put(
      url: '$_root/account/$id/activeState',
      mapper: ControllerApi.nullMapper,
    );
  }
}
