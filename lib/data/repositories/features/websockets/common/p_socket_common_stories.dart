import 'package:flavormate/data/models/features/websockets/socket_common_type.dart';
import 'package:flavormate/data/repositories/features/websockets/common/p_socket_common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_socket_common_stories.g.dart';

@riverpod
class PSocketCommonStories extends _$PSocketCommonStories {
  @override
  Stream<SocketCommonType> build() async* {
    final value = await ref.watch(pSocketCommonProvider.future);

    if (value == .NewStories) {
      yield value;
    }
  }

  @override
  bool updateShouldNotify(
    AsyncValue<dynamic> previous,
    AsyncValue<dynamic> next,
  ) {
    return true;
  }
}
