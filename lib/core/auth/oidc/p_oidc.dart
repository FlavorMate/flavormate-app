import 'package:flavormate/core/apis/rest/p_dio_auth.dart';
import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/data/datasources/extensions/oidc_controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_oidc.g.dart';

@riverpod
class POIDC extends _$POIDC {
  @override
  Future<List<OIDCProvider>> build() async {
    final dio = ref.watch(pDioPublicProvider);

    final client = OIDCControllerApi(dio);

    final response = await client.getProviders();

    return response.hasError ? [] : response.data!;
  }

  Future<String?> requestTokens(OIDCProvider provider) async {
    try {
      const appAuth = FlutterAppAuth();

      final AuthorizationTokenResponse result = await appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              provider.clientId,
              'flavormate://oauth',
              discoveryUrl: provider.url,
              scopes: ['openid', 'profile', 'email', 'offline_access', 'api'],
            ),
          );

      return result.accessToken;
    } catch (_) {
      return null;
    }
  }

  Future<bool> login(String accessToken) async {
    try {
      await ref.read(pAuthProvider.notifier).oidcLogin(accessToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> linkAccount(
    String accessToken,
    String username,
    String password,
  ) async {
    try {
      final dio = ref.read(pDioAuthProvider(accessToken));

      final client = OIDCControllerApi(dio);

      final response = await client.linkAccount(
        form: AuthLoginForm(username: username, password: password),
      );

      if (response.hasError) return false;

      await ref.read(pAuthProvider.notifier).setJwt(response.data!);

      return true;
    } catch (e) {
      return false;
    }
  }
}
