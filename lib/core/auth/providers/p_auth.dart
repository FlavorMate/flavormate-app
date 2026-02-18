import 'package:flavormate/core/apis/rest/p_dio_auth.dart';
import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/cache/provider/p_cached_image_manager.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/navigation/p_go_router.dart';
import 'package:flavormate/core/storage/secure_storage/providers/p_secure_storage.dart';
import 'package:flavormate/core/storage/secure_storage/providers/p_ss_jwt.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_recent_servers.dart';
import 'package:flavormate/data/datasources/core/auth_controller_api.dart';
import 'package:flavormate/data/datasources/extensions/oidc_controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth.g.dart';

@Riverpod(keepAlive: true)
class PAuth extends _$PAuth {
  @override
  TokensDto build() {
    final jwt = ref.watch(pSSJwtProvider);
    if (jwt.value == null) throw Exception('No JWT found!');
    return jwt.value!;
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

    await setJwt(jwt.data!);
  }

  Future<void> setJwt(TokensDto jwt) async {
    await ref.read(pSSJwtProvider.notifier).setValue(jwt);

    await ref.read(pSPRecentServersProvider.notifier).addServer();

    ref.invalidateSelf();
  }

  Future<TokensDto?> refreshToken() async {
    /// Capture the refresh token we are about to use.
    final tokenUsed = state.refreshToken;

    try {
      final dio = ref.read(pDioAuthProvider(state.refreshToken));
      final client = AuthControllerApi(dio);

      final response = await client.postRefreshToken();

      if (response.hasError) {
        throw Exception(
          response.error?.message ?? 'Error while refreshing token',
        );
      }

      await ref.read(pSSJwtProvider.notifier).setValue(response.data);

      return response.data;
    } catch (e) {
      /// If refresh failed, check whether someone else already refreshed successfully.
      /// If the refresh token changed since we started, this failure is almost certainly
      /// due to a race condition (we used an already-rotated refresh token).
      final currentTokens = ref.read(pSSJwtProvider).value;
      final refreshTokenChanged = currentTokens?.refreshToken != tokenUsed;

      if (refreshTokenChanged) {
        /// Ignore: a valid token exists now.
        return currentTokens;
      }

      /// Real failure for the current token => log out user.
      await logout();
      return null;
    }
  }

  Future<void> logout() async {
    try {
      final dio = ref.read(pDioAuthProvider(state.refreshToken));
      final client = AuthControllerApi(dio);

      await client.logout();
    } catch (_) {
      if (kDebugMode) {
        print("Couldn't logout on server");
      }
    }

    // Clear shared preferences
    await ref.read(pCachedImageManagerProvider.notifier).clear();
    await ref.read(pSecureStorageProvider.notifier).clear();
    await ref.read(pSPProvider.notifier).clear();

    navigationKey.currentContext!.routes.server(replace: true);
  }
}
