import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';

part 'account_update_dto.mapper.dart';

@MappableClass()
class AccountUpdateDto with AccountUpdateDtoMappable {
  final Diet? diet;
  final String? email;
  final String? oldPassword;
  final String? newPassword;

  const AccountUpdateDto({
    this.diet,
    this.email,
    this.oldPassword,
    this.newPassword,
  });
}
