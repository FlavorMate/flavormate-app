import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/router/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_go_router.g.dart';

final navigationKey = GlobalKey<NavigatorState>();

@Riverpod()
class PGoRouter extends _$PGoRouter {
  @override
  GoRouter build() {
    final authStateNotifier = ValueNotifier(AuthState.unknown);
    ref
      ..onDispose(authStateNotifier.dispose)
      ..listen(pAuthStateProvider, (_, value) {
        authStateNotifier.value = value;
      });

    final router = GoRouter(
      navigatorKey: navigationKey,
      debugLogDiagnostics: kDebugMode,
      initialLocation: '/home',
      routes: routes,
      refreshListenable: authStateNotifier,
      redirect: (_, state) {
        // Get the current auth state.
        final authState = ref.read(pAuthStateProvider);

        // Check if the current path is allowed for the current auth state. If not,
        // redirect to the redirect target of the current auth state.
        if (!authState.allowedPaths.contains(state.fullPath)) {
          return authState.redirectPath;
        }

        // If the current path is allowed for the current auth state, don't redirect.
        return null;
      },
    );

    ref.onDispose(router.dispose);

    return router;
  }
}
