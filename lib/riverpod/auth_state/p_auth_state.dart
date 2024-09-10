import 'package:flavormate/models/api/login.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/riverpod/shared_preferences/p_tokens.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth_state.g.dart';

/// The current authentication state of the app.
///
/// This notifier is responsible for saving/removing the token and profile info
/// to the storage through the [login] and [logout] methods.
@riverpod
class PAuthState extends _$PAuthState {
  @override
  AuthState build() {
    final prefs = ref.watch(pSharedPreferencesProvider).requireValue;

    final tokens = prefs.getString('token');

    return tokens != null ? AuthState.authenticated : AuthState.unauthenticated;
  }

  /// Attempts to log in with [data] and saves the token and profile info to storage.
  /// Will invalidate the state if success.
  Future<void> login(Login data) async {
    final prefs = ref.read(pSharedPreferencesProvider).requireValue;
    final token = await ref.read(pApiProvider).login(data);

    // Save the new [token] and [profile] to secure storage.
    if (token == null) {
      prefs.remove('token');
    } else {
      prefs.setString('token', token.toJson());
    }

    ref
      // Invalidate the state so the auth state will be updated to authenticated.
      ..invalidateSelf()
      // Invalidate the token provider so the API service will use the new token.
      ..invalidate(pTokensProvider);
  }

  /// Logs out, deletes the saved token and profile info from storage, and invalidates
  /// the state.
  void logout() {
    final prefs = ref.read(pSharedPreferencesProvider).requireValue;

    // Delete the current [token] and [profile] from secure storage.
    prefs.remove('token');

    ref
      // Invalidate the state so the auth state will be updated to unauthenticated.
      ..invalidateSelf()
      // Invalidate the token provider so the API service will no longer use the
      // previous token.
      ..invalidate(pTokensProvider);
  }
}

/// The possible authentication states of the app.
enum AuthState {
  unknown(
    redirectPath: '/',
    allowedPaths: [
      '/',
    ],
  ),
  unauthenticated(
    redirectPath: '/login',
    allowedPaths: [
      '/login',
    ],
  ),
  authenticated(
    redirectPath: '/home',
    allowedPaths: [
      '/home',
      '/library',
      '/library/:id',
      '/more',
      '/settings',
      '/no_connection',
      '/recipe/:id',
      '/recipes',
      '/search',
      '/categories',
      '/categories/:id',
      '/tags',
      '/tags/:id',
      '/authors',
      '/authors/:id',
      '/editor/:id',
      '/admin/user',
    ],
  ),
  ;

  const AuthState({
    required this.redirectPath,
    required this.allowedPaths,
  });

  /// The target path to redirect when the current route is not allowed in this
  /// auth state.
  final String redirectPath;

  /// List of paths allowed when the app is in this auth state.
  final List<String> allowedPaths;
}
