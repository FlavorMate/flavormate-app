import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/data/models/core/version/version.dart';

class LoginPageWrapper {
  final bool isStatic;
  final String server;
  final VersionComparison compatibility;
  final bool enableRegistration;
  final bool enableRecovery;
  final List<OIDCProvider> oidcProviders;

  LoginPageWrapper({
    required this.isStatic,
    required this.server,
    required this.compatibility,
    required this.enableRegistration,
    required this.enableRecovery,
    required this.oidcProviders,
  });
}
