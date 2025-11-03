import 'package:dart_mappable/dart_mappable.dart';

part 'oidc_provider.mapper.dart';

@MappableClass()
class OIDCProvider with OIDCProviderMappable {
  final String name;
  final String url;
  final String clientId;
  final String id;
  final String? iconPath;

  const OIDCProvider(
    this.name,
    this.url,
    this.clientId,
    this.id,
    this.iconPath,
  );
}
