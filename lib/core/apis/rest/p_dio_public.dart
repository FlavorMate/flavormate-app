import 'package:dio/dio.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_dio_public.g.dart';

@Riverpod(keepAlive: true)
class PDioPublic extends _$PDioPublic {
  @override
  Dio build() {
    final server = ref.watch(pSPCurrentServerProvider);
    if (server == null) throw Exception('No server specified!');

    final language = currentLocalization().languageCode;

    final dio = Dio();
    // Add base configuration
    dio.options.baseUrl = server;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers['Accept'] = 'application/json, text/plain';
    dio.options.headers['Accept-Language'] = language;

    return dio;
  }
}
