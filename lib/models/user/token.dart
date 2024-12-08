import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/user/user.dart';

part 'token.mapper.dart';

@MappableClass()
class Tokens with TokensMappable {
  final Token? accessToken;
  final Token? refreshToken;

  Tokens({required this.accessToken, required this.refreshToken});
}

@MappableClass()
class Token with TokenMappable {
  final String token;
  final int expiresIn;

  Token({required this.token, required this.expiresIn});
}

@MappableClass()
class TToken extends Entity with TTokenMappable {
  final String token;
  final Duration? validFor;
  final String type;
  final int? content;
  final User owner;
  final int uses;

  TToken({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.token,
    required this.validFor,
    required this.type,
    required this.content,
    required this.owner,
    required this.uses,
  });

  DateTime? get validUntil =>
      validFor != null ? createdOn!.add(validFor!) : null;
}
