import 'package:dart_mappable/dart_mappable.dart';

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
