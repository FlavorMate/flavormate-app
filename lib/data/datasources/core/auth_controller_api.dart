import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/session_dto.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/material.dart';

@immutable
class AuthControllerApi extends ControllerApi {
  static const _root = ApiConstants.CoreAuth;

  const AuthControllerApi(super.dio);

  Future<ApiResponse<TokensDto>> postLogin(AuthLoginForm form) async {
    final response = await post(
      url: '$_root/login',
      data: form.toJson(),
      mapper: (data) => TokensDtoMapper.fromMap(data),
    );

    return response;
  }

  Future<ApiResponse<TokensDto>> postRefreshToken() async {
    final response = await post(
      url: '$_root/refresh',
      mapper: (data) => TokensDtoMapper.fromMap(data),
    );

    return response;
  }

  Future<PageableDto<SessionDto>> getAllSessions({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/sessions',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<SessionDto>(data, SessionDto),
    );

    return response.data!;
  }

  Future<ApiResponse<bool>> deleteSession({required String id}) async {
    final response = await delete(
      url: '$_root/sessions/$id',
      mapper: (data) => bool.parse(data),
    );

    return response;
  }

  Future<ApiResponse<bool>> deleteAllSessionsButCurrent() async {
    final response = await delete(
      url: '$_root/sessions',
      mapper: (data) => bool.parse(data),
    );

    return response;
  }

  Future<ApiResponse<bool>> logout() async {
    return await post(url: '$_root/logout', mapper: (data) => bool.parse(data));
  }

  Future<ApiResponse<bool>> logoutAll() async {
    return await post(
      url: '$_root/logout/all',
      mapper: (data) => bool.parse(data),
    );
  }
}
