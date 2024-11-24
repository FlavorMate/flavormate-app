import 'package:app_links/app_links.dart';
import 'package:flavormate/extensions/e_number.dart';
import 'package:flavormate/extensions/e_uri.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/u_double.dart';
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

  void listener(Uri uri) {
    /// e.g. flavormate://flavormate.de?action=open&page=recipe&id=1&token=123
    /// e.g. flavormate://localhost:8095?action=open&page=recipe&id=1&token=123

    final foreign = uri.socket;
    final loggedIn = Uri.parse(ref.read(pServerProvider)).socket;

    if (foreign == loggedIn) {
      loggedInServer(uri.queryParameters);
    } else {
      foreignServer(uri.queryParameters);
    }
  }

  void foreignServer(Map<String, String> params) {
    if (params['action'] == 'open') {
      if (params['page'] == 'recipe') {
        final id = UDouble.tryParsePositive(params['id'] ?? '');
        final token = params['token'];
        if (id != null && token != null) {
          open('public', {
            'id': id.beautify,
            'token': token,
          });
        }
      }
    }
  }

  void loggedInServer(Map<String, String> params) {
    if (params['action'] == 'open') {
      if (params['page'] == 'recipe') {
        final id = UDouble.tryParsePositive(params['id'] ?? '');
        if (id != null) {
          open('recipe', {'id': id.beautify});
        }
      }
    }
  }

  void open(String page, Map<String, String>? params) {
    ref.read(pGoRouterProvider).pushNamed(
          page,
          pathParameters: params ?? {},
        );
  }
}
