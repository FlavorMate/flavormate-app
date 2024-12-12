import 'package:dart_mappable/dart_mappable.dart';

part 'login.mapper.dart';

@MappableClass()
class Login with LoginMappable {
  final String username;
  final String password;

  Login({required this.username, required this.password});
}
