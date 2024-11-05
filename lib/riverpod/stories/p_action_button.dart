import 'package:flavormate/riverpod/stories/p_story.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_action_button.g.dart';

@riverpod
class PActionButton extends _$PActionButton {
  @override
  Future<ActionButtonPermissions> build(int storyId) async {
    final story =
        await ref.watch(pStoryProvider(storyId).selectAsync((data) => data));
    final user = await ref.watch(pUserProvider.selectAsync((data) => data));

    return ActionButtonPermissions(
      isOwner: story.author.id == user.id!,
      isAdmin: user.isAdmin,
    );
  }
}

class ActionButtonPermissions {
  final bool isOwner;
  final bool isAdmin;

  ActionButtonPermissions({required this.isOwner, required this.isAdmin});
}
