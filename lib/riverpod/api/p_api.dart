import 'package:flavormate/clients/api_client.dart';
import 'package:flavormate/clients/interceptor_methods.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/riverpod/shared_preferences/p_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_api.g.dart';

@riverpod
class PApi extends _$PApi {
  @override
  ApiClient build() {
    final server = ref.watch(pServerProvider);
    final token = ref.watch(pTokensProvider);
    final auth = ref.read(pAuthStateProvider.notifier);

    ref.keepAlive();

    final interceptorMethods = InterceptorMethods(
      onUnauthenticated: auth.logout,
      onNoConnection: () =>
          ref.read(pGoRouterProvider).goNamed('no-connection'),
    );

    return token != null
        ? ApiClient.withToken(
            server, token.accessToken!.token, interceptorMethods)
        : ApiClient(server, interceptorMethods);
  }
}
