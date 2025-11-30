import 'package:cached_network_image/cached_network_image.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_cached_image.g.dart';

@riverpod
class PCachedImage extends _$PCachedImage {
  @override
  Future<CachedNetworkImageProvider?> build(String? path) async {
    if (path == null) return null;

    final host = ref.watch(pSPCurrentServerProvider);

    if (host == null) return null;

    final token = await ref.read(pDioPrivateProvider.notifier).getTokenSync();

    if (token == null) return null;

    return CachedNetworkImageProvider(
      '$host$path',
      headers: {'Authorization': token},
    );
  }
}
