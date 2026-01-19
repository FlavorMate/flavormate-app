import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

part 'oidc_provider.mapper.dart';

@MappableClass()
class OIDCProvider with OIDCProviderMappable {
  final String label;
  final String url;
  final String issuer;
  final String clientId;
  final String id;
  final String redirectUri;
  final Uint8List? icon;

  const OIDCProvider(
    this.label,
    this.url,
    this.issuer,
    this.clientId,
    this.id,
    this.icon, {
    this.redirectUri = 'flavormate://oauth',
  });
}
