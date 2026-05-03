import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/features/websockets/socket_common_type.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:websocket_universal/websocket_universal.dart';

part 'p_socket_common.g.dart';

@Riverpod(keepAlive: true)
class PSocketCommon extends _$PSocketCommon {
  static const _root = 'v3/websocket/common';

  @override
  Stream<SocketCommonType> build() async* {
    // Since auth in websockets is not supported in web, disable them here
    if (kIsWeb || kIsWasm) {
      yield .Empty;
    }

    final server = ref.watch(pSPCurrentServerProvider)!;
    final auth = ref.watch(pAuthProvider);

    final wsUrl = Uri.parse('$server/$_root').replace(scheme: 'ws');

    /// 1. Create webSocket handler:
    final textSocketHandler = IWebSocketHandler<String, String>.createClient(
      wsUrl.toString(),
      SocketSimpleTextProcessor(),
    );

    /// 3. Connect & send message:
    await textSocketHandler.connect(
      params: .new(headers: {'Authorization': 'Bearer ${auth.accessToken}'}),
    );

    ref.onDispose(() async {
      await textSocketHandler.disconnect('manual disconnect');
      textSocketHandler.close();
    });

    await for (final message in textSocketHandler.incomingMessagesStream) {
      final parsedMessage = _parseMessage(message);

      if (parsedMessage == null) continue;

      yield parsedMessage;
    }
  }

  @override
  bool updateShouldNotify(
    AsyncValue<dynamic> previous,
    AsyncValue<dynamic> next,
  ) {
    return true;
  }

  static SocketCommonType? _parseMessage(String data) {
    try {
      return SocketCommonTypeMapper.fromValue(data);
    } catch (_) {
      return null;
    }
  }
}
