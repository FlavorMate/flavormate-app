import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_auth_header.g.dart';

@Riverpod(keepAlive: true)
class PAuthHeader extends _$PAuthHeader {
  Future<String?>? _refreshInFlight;

  @override
  void build() {
    // no state; acts like a service
  }

  Future<String?> authHeader({bool forceRefresh = false}) async {
    // Wait for any in-flight refresh so nobody uses an old token mid-refresh.
    final inflight = _refreshInFlight;
    if (inflight != null) {
      try {
        await inflight;
      } catch (_) {
        // ignore; caller will handle null / error
      }
    }

    final tokens = ref.read(pAuthProvider);
    final accessToken = tokens.accessToken;

    if (!forceRefresh) {
      if (accessToken.isEmpty) return null;
      if (!tokens.accessTokenAboutToExpire) return 'Bearer $accessToken';
      // else: about to expire => refresh below
    }

    final refreshedAccessToken = await _refreshAccessTokenSingleFlight();
    if (refreshedAccessToken == null || refreshedAccessToken.isEmpty) {
      return null;
    }
    return 'Bearer $refreshedAccessToken';
  }

  Future<String?> _refreshAccessTokenSingleFlight() {
    final existing = _refreshInFlight;
    if (existing != null) return existing;

    final future = () async {
      final refreshed = await ref.read(pAuthProvider.notifier).refreshToken();
      return refreshed?.accessToken;
    }();

    _refreshInFlight = future.whenComplete(() => _refreshInFlight = null);
    return _refreshInFlight!;
  }
}
