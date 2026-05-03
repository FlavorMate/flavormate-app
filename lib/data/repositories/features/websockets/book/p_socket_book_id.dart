import 'dart:async';

import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:websocket_universal/websocket_universal.dart';

part 'p_socket_book_id.g.dart';

@Riverpod(keepAlive: true)
class PSocketBookId extends _$PSocketBookId {
  static const _root = 'v3/websocket/book';

  @override
  Stream<String?> build(String id) async* {
    // Since auth in websockets is not supported in web, disable them here
    if (kIsWeb || kIsWasm) {
      yield null;
    }

    final server = ref.watch(pSPCurrentServerProvider)!;
    final auth = ref.read(pAuthProvider);

    final wsUrl = Uri.parse('$server/$_root/$id').replace(scheme: 'ws');

    print("Create book $id socket");

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
      yield message;
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
