import 'package:flavormate/models/entity.dart';
import 'package:flavormate/models/file/file.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/user/role.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User extends Entity with UserMappable {
  final String displayName;

  final String username;

  final String? mail;

  final File? avatar;

  final DateTime? lastActivity;

  final List<AccountHistory>? history;

  final bool? valid;

  final List<Role>? roles;

  final Diet? diet;

  User({
    required this.mail,
    required this.avatar,
    required this.lastActivity,
    required this.history,
    required this.diet,
    required this.username,
    required this.displayName,
    required this.valid,
    required this.roles,
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
  });

  bool get isAdmin =>
      (roles?.indexWhere((role) => role.label == 'ROLE_ADMIN') ?? -1) >= 0;
}

@MappableClass()
class AccountHistory extends Entity with AccountHistoryMappable {
  final String name;

  final Map<String, String> params;

  final Map<String, String> query;

  AccountHistory({
    required super.id,
    required super.version,
    required super.createdOn,
    required super.lastModifiedOn,
    required this.name,
    required this.params,
    required this.query,
  });
}
