import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
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
}
