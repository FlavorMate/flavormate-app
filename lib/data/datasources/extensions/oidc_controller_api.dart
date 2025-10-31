import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/data/datasources/controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

class OIDCControllerApi extends ControllerApi {
  static const _root = ApiConstants.ExtensionOIDC;

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
}
