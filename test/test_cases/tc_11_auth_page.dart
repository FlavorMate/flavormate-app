import 'package:flavormate/core/cache/cache_image_provider.dart';
import 'package:flavormate/core/cache/provider/p_cached_image.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/settings/p_settings_image_mode.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/presentation/features/auth/auth_page.dart';
import 'package:flavormate/presentation/features/auth/models/login_page_wrapper.dart';
import 'package:flavormate/presentation/features/auth/providers/p_login_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'tc.dart';

class TC11AuthPage extends TC {
  const TC11AuthPage({
    required super.locale,
    required super.assets,
  });

  @override
  List<Override> get overrides {
    return [
      pLoginPageProvider.overrideWithBuild(
        (ref, it) => LoginPageWrapper(
          isStatic: false,
          server: 'https://example.flavormate.de',
          compatibility: .fullyCompatible,
          enableRegistration: true,
          enableRecovery: true,
          oidcProviders: [
            OIDCProvider('Authentik', '', '', '', 'auth', null),
            OIDCProvider('Goolge', '', '', '', 'google', null),
            OIDCProvider('PocketID', '', '', '', 'pid', null),
          ],
        ),
      ),

      pSettingsImageModeProvider.overrideWithValue(.Scale),
      pCachedImageProvider.overrideWithBuild(
        (ref, it) => CacheImageProvider(
          url: it.url,
          imageLoader: (url) async {
            final asset = await assets.load(url.split('?')[0]);
            return asset.buffer.asUint8List();
          },
        ),
      ),
    ];
  }

  @override
  void run() {
    screenshot(
      '11_auth_login_page',
      const AuthPage(),
    );
  }
}
