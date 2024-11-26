import 'package:app_links/app_links.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/models/appLink/app_link.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flutter/material.dart';
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

  /// The url contains the following informations:
  /// - server  -> the server url in base64
  /// - page    -> the destination page
  /// - id      -> the destination id (e.g. recipe id)
  /// - token   -> the token to get temporary access to the server
  ///
  /// e.g. `flavormate://open?server=aHR0cDovL2xvY2FsaG9zdDo4MDk1&page=recipe&id=111&token=2222e1ad-76cf-4aa6-ab41-78a2337e6ba5`
  void listener(Uri uri) {
    final appLink = AppLink.decode(uri.queryParameters);

    final foreign = Uri.parse(appLink.server);
    final loggedIn = Uri.parse(ref.read(pServerProvider));

    if (foreign == loggedIn) {
      loggedInServer(uri.host, appLink);
    } else {
      navigationKey.currentContext!.showTextSnackBar(
        'Foreign server are not supported yet!',
        color: Colors.red,
      );
      // TODO: add public sites
      // foreignServer(uri.host, appLink);
    }
  }

  void foreignServer(String action, AppLink appLink) {
    if (action == AppLinkMode.open.name) {
      if (appLink.page == 'recipe') {
        open('public', {
          'id': appLink.id.toString(),
          'token': appLink.token,
        });
      }
    }
  }

  void loggedInServer(String action, AppLink appLink) {
    if (action == AppLinkMode.open.name) {
      if (appLink.page == 'recipe') {
        open('recipe', {'id': appLink.id.toString()});
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
