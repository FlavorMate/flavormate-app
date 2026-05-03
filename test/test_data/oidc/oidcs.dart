import 'package:collection/collection.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';

class OIDCs {
  static List<OIDCProvider> getProviders() {
    return [
      authentik,
      google,
      pocketId,
    ].sorted((a, b) => a.label.compareToIgnoreCase(b.label));
  }

  static const authentik = OIDCProvider(
    'Authentik',
    '',
    '',
    '',
    'authentik',
    null,
  );
  
  static const google = OIDCProvider(
    'Goolge',
    '',
    '',
    '',
    'google',
    null,
  );

  static const pocketId = OIDCProvider(
    'PocketID',
    '',
    '',
    '',
    'pocketID',
    null,
  );
}
