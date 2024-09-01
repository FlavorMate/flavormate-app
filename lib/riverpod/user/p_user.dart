import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/models/user/user.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_user.g.dart';

@riverpod
class PUser extends _$PUser {
  @override
  Future<User> build() async {
    return await ref.watch(pApiProvider).userClient.getUser();
  }

  Future<void> setDiet(Diet diet) async {
    await ref
        .read(pApiProvider)
        .userClient
        .update(state.value!.id!, data: {'diet': diet.name});

    // ref.invalidate(pHighlightProvider);
    ref.invalidateSelf();
  }

  Future<bool> setMail(String mail) async {
    try {
      await ref
          .read(pApiProvider)
          .userClient
          .update(state.value!.id!, data: {'mail': mail});

      ref.invalidateSelf();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setPassword(Map password) async {
    final response = await ref
        .read(pApiProvider)
        .userClient
        .setPassword(state.value!.id!, password);

    ref.invalidateSelf();

    return response;
  }
}
