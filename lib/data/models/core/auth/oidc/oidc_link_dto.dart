import 'dart:typed_data';

import 'package:dart_mappable/dart_mappable.dart';

part 'oidc_link_dto.mapper.dart';

@MappableClass()
class OidcLinkDto with OidcLinkDtoMappable {
  final String issuer;
  final String subject;
  final String name;
  final DateTime createdOn;
  final String providerId;
  final String providerName;
  final Uint8List? icon;

  const OidcLinkDto(
    this.issuer,
    this.subject,
    this.name,
    this.createdOn,
    this.providerId,
    this.providerName,
    this.icon,
  );

  String get host => Uri.parse(issuer).host;
}
