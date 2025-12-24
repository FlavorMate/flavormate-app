import 'package:app_links/app_links.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/navigation/p_go_router.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_app_links.g.dart';

@riverpod
class PAppLinks extends _$PAppLinks {
  @override
  void build() {
    final appLinks = AppLinks();

    ref.keepAlive();

    // Subscribe to all events (initial link and further)
    final sub = appLinks.uriLinkStream.listen(listener);

    ref.onDispose(() {
      sub.cancel();
    });
  }

  /// The url contains the following information:
  /// - server  -> the server url in base64
  /// - type    -> the destination page
  /// - id      -> the destination id (e.g. recipe id)
  /// - token   -> the token to get temporary access to the server
  ///
  /// e.g. `flavormate://open?server=http://localhost:8080&page=recipe&id=111&token=2222e1ad-76cf-4aa6-ab41-78a2337e6ba5`
  void listener(Uri uri) async {
    final action = uri.host;

    final server = uri.queryParameters['server'];
    final type = uri.queryParameters['type'];
    final id = uri.queryParameters['id'];
    final token = uri.queryParameters['token'];

    if (action != 'open' ||
        server?.trimToNull == null ||
        type?.trimToNull == null ||
        id?.trimToNull == null ||
        token?.trimToNull == null) {
      navigationKey.currentContext!.showErrorSnackBar(
        'Request is not valid!',
      );
      return;
    }

    final currentServer = ref.read(pSPCurrentServerProvider);

    if (currentServer != server!) {
      navigationKey.currentContext!.showErrorSnackBar(
        'Foreign servers are not supported yet!',
      );
      return;
    }

    if (type == 'recipe') {
      navigationKey.currentContext!.routes.recipesItem(id!);
    }

    return;
  }
}
