import 'package:cached_network_image/cached_network_image.dart';
import 'package:flavormate/core/apis/rest/p_secure_image_cache_manager.dart';
import 'package:flavormate/core/auth/providers/p_auth_header.dart';
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

    final token = await ref.read(pAuthHeaderProvider.notifier).authHeader();
    if (token == null) return null;

    final cacheManager = ref.watch(pSecureImageCacheManagerProvider);

    final url = '$host$path';

    return CachedNetworkImageProvider(
      url,
      cacheManager: cacheManager,
      cacheKey: url,
    );
  }
}
