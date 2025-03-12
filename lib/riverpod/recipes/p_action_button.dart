import 'package:flavormate/riverpod/recipes/p_recipe.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_action_button.g.dart';

@riverpod
class PActionButton extends _$PActionButton {
  @override
  Future<ActionButtonPermissions> build(int recipeId) async {
    final recipe = await ref.watch(
      pRecipeProvider(recipeId).selectAsync((data) => data),
    );
    final user = await ref.watch(pUserProvider.selectAsync((data) => data));

    return ActionButtonPermissions(
      isOwner: recipe.author!.id == user.id!,
      isAdmin: user.isAdmin,
    );
  }
}

class ActionButtonPermissions {
  final bool isOwner;
  final bool isAdmin;

  ActionButtonPermissions({required this.isOwner, required this.isAdmin});
}
