import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flavormate/core/apis/rest/p_dio_auth.dart';
import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/config/app_links/p_app_links.dart';
import 'package:flavormate/data/datasources/extensions/oidc_controller_api.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';

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
      final scopes = ['openid'];

      // 1. PKCE
      final codeVerifier = _generateCodeVerifier();
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      // 2. Discovery
      final discoveryUrl = provider.url;
      final discoveryResp = await http.get(Uri.parse(discoveryUrl));
      final discovery = jsonDecode(discoveryResp.body);
      final authEndpoint = discovery['authorization_endpoint'] as String;

      // 3. Open browser
      await _openAuthUrl(
        clientId: provider.clientId,
        redirectUri: provider.redirectUri,
        codeChallenge: codeChallenge,
        scopes: scopes,
        authorizationEndpoint: authEndpoint,
      );

      // 4. Listen for redirect
      final codeUri = await ref
          .read(pAppLinksProvider.notifier)
          .waitForNextElement();

      final code = codeUri.queryParameters['code']!;

      // 5. Exchange code for id token
      final dio = ref.read(pDioPublicProvider);
      final client = OIDCControllerApi(dio);

      final idToken = await client.exchangeCode(
        id: provider.id,
        code: code,
        codeVerifier: codeVerifier,
        redirectUri: provider.redirectUri,
      );

      return idToken.data;
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

  static String _generateCodeVerifier([int length = 128]) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }

  static String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  static Future<void> _openAuthUrl({
    required String clientId,
    required String redirectUri,
    required String codeChallenge,
    required List<String> scopes,
    required String authorizationEndpoint,
  }) async {
    final url = Uri.parse(authorizationEndpoint)
        .replace(
          queryParameters: {
            'client_id': clientId,
            'redirect_uri': redirectUri,
            'response_type': 'code',
            'scope': scopes.join(' '),
            'code_challenge': codeChallenge,
            'code_challenge_method': 'S256',
          },
        )
        .toString();

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
