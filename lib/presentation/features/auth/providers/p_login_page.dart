import 'package:flavormate/core/auth/oidc/p_oidc.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/config/features/p_feature_recovery.dart';
import 'package:flavormate/core/config/features/p_feature_registration.dart';
import 'package:flavormate/core/storage/root_bundle/backend_url/p_rb_backend_url.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/auth/auth_login_form.dart';
import 'package:flavormate/data/models/core/auth/tokens_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/core/server/p_server_compatibility.dart';
import 'package:flavormate/presentation/features/auth/models/login_page_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_login_page.g.dart';

@riverpod
class PLoginPage extends _$PLoginPage {
  @override
  Future<LoginPageWrapper> build() async {
    final fixedServer = ref.watch(pRBBackendUrlProvider).requireValue;
    final server = ref.watch(pSPCurrentServerProvider)!;
    final compatibility = await ref.watch(pServerCompatibilityProvider.future);
    final enableRegistration = ref.watch(pFeatureRegistrationProvider);
    final enableRecovery = ref.watch(pFeatureRecoveryProvider);
    final oidcProviders = await ref.watch(pOIDCProvider.future);

    return LoginPageWrapper(
      isStatic: fixedServer != null,
      server: server,
      compatibility: compatibility,
      enableRegistration: enableRegistration,
      enableRecovery: enableRecovery,
      oidcProviders: oidcProviders,
    );
  }

  Future<ApiResponse<TokensDto>> login(String username, String password) async {
    return await ref
        .read(pAuthProvider.notifier)
        .login(
          AuthLoginForm(
            username: username,
            password: password,
          ),
        );
  }

  Future<void> resetServer() async {
    await ref.read(pSPCurrentServerProvider.notifier).set(null);
  }

  void invalidate() {
    ref.invalidate(pServerCompatibilityProvider);
    ref.invalidate(pOIDCProvider);
    ref.invalidateSelf();
  }
}
