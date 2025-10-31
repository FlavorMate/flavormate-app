import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'auth_login_form.mapper.dart';

@immutable
@MappableClass()
class AuthLoginForm with AuthLoginFormMappable {
  final String username;
  final String password;

  const AuthLoginForm({required this.username, required this.password});
}
