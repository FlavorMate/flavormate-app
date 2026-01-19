import 'dart:convert';

import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_link_dto.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class OIDCControllerApi extends ControllerApi {
  static const _root = ApiConstants.ExtensionOIDC2;

  const OIDCControllerApi(super.dio);

  Future<ApiResponse<List<OIDCProvider>>> getProviders() async {
    return await get(
      url: '$_root/',
      mapper: (data) => List<Map<String, dynamic>>.from(
        data,
      ).map(OIDCProviderMapper.fromMap).toList(),
    );
  }

  Future<ApiResponse<TokensDto>> login({required String accessToken}) async {
    return get(
      url: '$_root/login',
      mapper: (data) => TokensDtoMapper.fromMap(data),
    );
  }

  Future<ApiResponse<TokensDto>> linkAccount({
    required AuthLoginForm form,
  }) async {
    return await post(
      url: '$_root/link',
      data: form.toJson(),
      mapper: (data) => TokensDtoMapper.fromMap(data),
    );
  }

  Future<PageableDto<OidcLinkDto>> getLinks({
    int? page,
    int? pageSize,
    OrderBy? orderBy,
    OrderDirection? orderDirection,
  }) async {
    final response = await get(
      url: '$_root/link',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'orderBy': orderBy?.name,
        'orderDirection': orderDirection?.name,
      },
      mapper: (data) => PageableDto.fromAPI<OidcLinkDto>(data, OidcLinkDto),
    );

    return response.data!;
  }

  Future<ApiResponse<bool>> deleteLink({required String providerId}) async {
    return await delete(
      url: '$_root/link/$providerId',
      mapper: (data) => bool.parse(data),
    );
  }

  Future<ApiResponse<String>> exchangeCode({
    required String issuer,
    required String clientId,
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) async {
    return await post(
      url: '$_root/exchange-code',
      data: jsonEncode({
        'issuer': issuer,
        'clientId': clientId,
        'code': code,
        'codeVerifier': codeVerifier,
        'redirectUri': redirectUri,
      }),
      mapper: (data) => data as String,
    );
  }
}
