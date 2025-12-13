import 'package:dio/dio.dart';
import 'package:flavormate/core/auth/providers/p_auth_header.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_dio_private.g.dart';

@Riverpod(keepAlive: true)
class PDioPrivate extends _$PDioPrivate {
  @override
  Dio build() {
    final server = ref.watch(pSPCurrentServerProvider);

    if (server == null) throw Exception('No server specified');

    final language = currentLocalization().languageCode;

    final dio = Dio();
    // Add base configuration
    dio.options.baseUrl = server;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers['Accept'] = 'application/json, text/plain';
    dio.options.headers['Accept-Language'] = language;

    // Add interceptors for token management
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] = await ref
              .read(pAuthHeaderProvider.notifier)
              .authHeader();

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            try {
              // Retry the original request
              final opts = error.requestOptions;
              opts.headers['Authorization'] = await ref
                  .read(pAuthHeaderProvider.notifier)
                  .authHeader(forceRefresh: true);
              final response = await dio.fetch(opts);
              return handler.resolve(response);
            } catch (e) {
              // Handle refresh token failure
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );

    // Keep the Dio instance alive
    ref.keepAlive();

    return dio;
  }
}
