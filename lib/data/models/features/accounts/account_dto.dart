import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/features/accounts/account_file_dto.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flutter/material.dart';

part 'account_dto.mapper.dart';

@immutable
@MappableClass(includeSubClasses: [AccountPreviewDto, AccountFullDto])
abstract class AccountDto with AccountDtoMappable {
  final String id;
  final String displayName;
  final AccountFileDto? avatar;

  const AccountDto({
    required this.id,
    required this.displayName,
    required this.avatar,
  });
}

@MappableClass()
class AccountPreviewDto extends AccountDto with AccountPreviewDtoMappable {
  const AccountPreviewDto({
    required super.id,
    required super.displayName,
    required super.avatar,
  });
}

@MappableClass()
class AccountFullDto extends AccountDto with AccountFullDtoMappable {
  final String username;
  final Diet diet;
  final String email;
  final bool enabled;
  final bool verified;
  final bool firstLogin;
  final DateTime createdOn;
  final List<String> roles;

  const AccountFullDto({
    required super.id,
    required super.displayName,
    required super.avatar,
    required this.username,
    required this.diet,
    required this.email,
    required this.enabled,
    required this.verified,
    required this.firstLogin,
    required this.createdOn,
    required this.roles,
  });

  bool get isAdmin => roles.contains('Admin');
}
