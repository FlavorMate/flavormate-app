import 'package:dart_mappable/dart_mappable.dart';

part 'session_dto.mapper.dart';

@MappableClass()
class SessionDto with SessionDtoMappable {
  final String id;
  final String tokenHash;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  final DateTime expiresAt;
  final bool revoked;
  final UserAgent? userAgent;

  const SessionDto(
    this.id,
    this.tokenHash,
    this.createdAt,
    this.lastModifiedAt,
    this.expiresAt,
    this.revoked,
    this.userAgent,
  );
}

class UserAgent {
  static final _userAgentRegex = RegExp(
    r'^(FlavorMate)/([0-9]+\.[0-9]+\.[0-9]+) \((.+); (.+)\)$',
  );

  final String app;
  final String version;
  final String device;
  final String os;

  const UserAgent(this.app, this.version, this.device, this.os);

  factory UserAgent.parse(String input) {
    final groups = _userAgentRegex.firstMatch(input);

    return UserAgent(
      groups?.group(1) ?? '-',
      groups?.group(2) ?? '-',
      groups?.group(3) ?? '-',
      groups?.group(4) ?? '-',
    );
  }
}
