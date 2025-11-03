import 'package:flavormate/core/apis/rest/p_dio_auth.dart';
import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_jwt.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_recent_servers.dart';
import 'package:flavormate/data/datasources/core/auth_controller_api.dart';
import 'package:flavormate/data/datasources/extensions/oidc_controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth.g.dart';

@Riverpod(keepAlive: true)
class PAuth extends _$PAuth {
  @override
  TokensDto build() {
    final jwt = ref.watch(pSPJwtProvider);
    if (jwt == null) throw Exception('No JWT found!');
    return jwt;
  }

  Future<ApiResponse<TokensDto>> login(AuthLoginForm loginForm) async {
    final dio = ref.read(pDioPublicProvider);

    final client = AuthControllerApi(dio);

    final response = await client.postLogin(loginForm);

    if (response.hasData) {
      await setJwt(response.data!);
    }

    return response;
  }

  Future<void> oidcLogin(String oidcAccessToken) async {
    final dio = ref.read(pDioAuthProvider(oidcAccessToken));

    final client = OIDCControllerApi(dio);

    final jwt = await client.login(accessToken: oidcAccessToken);

    // TODO: handle this case
    if (jwt.hasError) return;

    await setJwt(jwt.data!);
  }

  Future<void> setJwt(TokensDto jwt) async {
    ref.read(pSPJwtProvider.notifier).setValue(jwt);

    await ref.read(pSPRecentServersProvider.notifier).addServer();

    ref.invalidateSelf();
  }

  Future<TokensDto?> refreshToken() async {
    try {
      final dio = ref.read(pDioAuthProvider(state.refreshToken));

      final client = AuthControllerApi(dio);

      final response = await client.postRefreshToken();

      await ref.read(pSPJwtProvider.notifier).setValue(response.data!);

      return response.data;
    } catch (e) {
      await logout();
    }
    return null;
  }

  Future<void> logout() async {
    // Clear shared preferences
    await ref.read(pSPProvider.notifier).clear();
  }
}
