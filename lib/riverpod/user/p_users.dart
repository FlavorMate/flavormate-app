import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/user/user.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_users.g.dart';

@riverpod
class PUsers extends _$PUsers {
  @override
  Future<List<User>> build() async {
    final users = await ref.watch(pApiProvider).userClient.findAll();
    users.sort((a, b) => a.displayName.compareToIgnoreCase(b.displayName));
    return users;
  }
}
