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

  void sortByUsername(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) => a.username.compareToIgnoreCase(b.username));
    } else {
      state.value!.sort((a, b) => b.username.compareToIgnoreCase(a.username));
    }
    ref.notifyListeners();
  }

  void sortByDisplayname(bool sortASC) {
    if (sortASC) {
      state.value!
          .sort((a, b) => a.displayName.compareToIgnoreCase(b.displayName));
    } else {
      state.value!
          .sort((a, b) => b.displayName.compareToIgnoreCase(a.displayName));
    }
    ref.notifyListeners();
  }

  void sortByLastActivity(bool sortASC) {
    if (sortASC) {
      state.value!.sort((a, b) => a.lastActivity!.compareTo(b.lastActivity!));
    } else {
      state.value!.sort((a, b) => b.lastActivity!.compareTo(a.lastActivity!));
    }
    ref.notifyListeners();
  }
}
