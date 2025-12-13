import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
BaseCacheManager pSecureImageCacheManager(Ref ref) {
  final fileService = _AuthRefreshingHttpFileService(
    headersProvider: ({required bool forceRefresh}) async {
      final auth = await ref
          .read(pAuthHeaderProvider.notifier)
          .authHeader(forceRefresh: forceRefresh);

      if (auth == null || auth.isEmpty) return const <String, String>{};

      return <String, String>{'Authorization': auth};
    },
  );

  return CacheManager(
    Config(
      'secure_images',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 500,
      fileService: fileService,
    ),
  );
}
