import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

part 'tokens_dto.mapper.dart';

@immutable
@MappableClass()
class TokensDto with TokensDtoMappable {
  static const _expireDuration = Duration(minutes: 1);

  final String tokenType = 'Bearer';
  @MappableField(key: 'access_token')
  final String accessToken;
  @MappableField(key: 'refresh_token')
  final String refreshToken;

  const TokensDto({required this.accessToken, required this.refreshToken});

  Duration get accessTokenExpires => JwtDecoder.getRemainingTime(accessToken);

  Duration get refreshTokenExpires => JwtDecoder.getRemainingTime(refreshToken);

  bool get accessTokenAboutToExpire =>
      accessTokenExpires.compareTo(_expireDuration) < 0;

  bool get refreshTokenAboutToExpires =>
      refreshTokenExpires.compareTo(_expireDuration) < 0;
}
