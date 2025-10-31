import 'package:dart_mappable/dart_mappable.dart';

part 'account_create_form.mapper.dart';

@MappableClass()
class AccountCreateForm with AccountCreateFormMappable {
  final String displayName;
  final String username;
  final String password;
  final String email;

  const AccountCreateForm({
    required this.displayName,
    required this.username,
    required this.password,
    required this.email,
  });
}
