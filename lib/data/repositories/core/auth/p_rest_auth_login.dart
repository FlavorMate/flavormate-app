import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/data/datasources/core/auth_controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_auth_login.g.dart';

@riverpod
class PRestAuthLogin extends _$PRestAuthLogin {
  @override
  void build() {}

  Future<ApiResponse<TokensDto>> login(AuthLoginForm form) async {
    final dio = ref.watch(pDioPublicProvider);

    final client = AuthControllerApi(dio);

    final response = await client.postLogin(form);

    return response;
  }
}
