import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flavormate/core/auth/providers/p_auth_header.dart';

part 'p_secure_image_cache_manager.g.dart';

class _AuthRefreshingHttpFileService extends FileService {
  final http.Client _client;
  final Future<Map<String, String>> Function({required bool forceRefresh})
  _headersProvider;

  _AuthRefreshingHttpFileService({
    http.Client? client,
    required Future<Map<String, String>> Function({required bool forceRefresh})
    headersProvider,
  }) : _client = client ?? http.Client(),
       _headersProvider = headersProvider;

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    Future<http.StreamedResponse> doRequest({
      required bool forceRefresh,
    }) async {
      final authHeaders = await _headersProvider(forceRefresh: forceRefresh);
      final merged = <String, String>{
        ...?headers,
        ...authHeaders,
      };

      final request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(merged);
      return _client.send(request);
    }

    // First attempt with current token (fast path).
    http.StreamedResponse response = await doRequest(forceRefresh: false);

    // If unauthorized, force refresh and retry once.
    if (response.statusCode == 401) {
      response = await doRequest(forceRefresh: true);
    }

    return HttpGetResponse(response);
  }
}

@Riverpod(keepAlive: true)
class PSecureImageCacheManager extends _$PSecureImageCacheManager {
  static const String _key = 'flavormate_cached_images';

  @override
  BaseCacheManager build() {
    final fileService = _AuthRefreshingHttpFileService(
      headersProvider: ({required bool forceRefresh}) async {
        final auth = await ref
            .read(pAuthHeaderProvider.notifier)
            .authHeader(forceRefresh: forceRefresh);

        if (auth == null || auth.isEmpty) return const <String, String>{};

        return <String, String>{'Authorization': auth};
      },
    );

    final config = Config(
      _key,
      fileService: fileService,
    );

    return CacheManager(config);
  }

  Future<void> clear() async {
    if (kIsWeb) return;
    await state.emptyCache();
    await _deleteCachedFiles(_key, recreate: true);

    // old values used in former app versions
    await _deleteCachedFiles('libCachedImageData');
    await _deleteCachedFiles('secure_images');
  }

  Future<void> _deleteCachedFiles(String key, {bool recreate = false}) async {
    final baseDir = await getTemporaryDirectory();

    final directory = io.Directory('${baseDir.path}/$key');

    if (await directory.exists()) {
      await directory.delete(recursive: true);
      if (recreate) await directory.create(recursive: true);
    }
  }
}
