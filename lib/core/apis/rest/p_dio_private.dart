import 'package:dio/dio.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/auth/providers/p_auth_header.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_dio_private.g.dart';

@Riverpod(keepAlive: true)
class PDioPrivate extends _$PDioPrivate {
  static const retryDuration = Duration(seconds: 1);
  static const maxRetries = 3;

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
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            options.headers['Authorization'] = await ref
                .read(pAuthHeaderProvider.notifier)
                .authHeader();
          } catch (_) {}

          return handler.next(options);
        },
      ),
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          int retryCount = 0;

          if (!_shouldRetry(error)) return handler.next(error);
          while (retryCount < maxRetries) {
            try {
              retryCount++;

              await Future.delayed(retryDuration * retryCount);

              // Retry the original request
              final opts = error.requestOptions;

              opts.headers['Authorization'] = await ref
                  .read(pAuthHeaderProvider.notifier)
                  .authHeader(forceRefresh: true);

              final response = await dio.fetch(opts);

              return handler.resolve(response);
            } on DioException catch (_) {
              if (retryCount >= maxRetries) {
                // Handle refresh token failure
                await ref.read(pAuthProvider.notifier).logout();
                return handler.reject(error);
              }
            }
          }

          return handler.next(error);
        },
      ),
    ]);

    // Keep the Dio instance alive
    ref.keepAlive();

    return dio;
  }

  bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;
    return switch (error.type) {
          DioExceptionType.badResponse => true,
          _ => false,
        } &&
        statusCode == 401;
  }
}
