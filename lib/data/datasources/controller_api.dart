import 'package:dio/dio.dart';
import 'package:flavormate/core/extensions/e_object.dart';
import 'package:flavormate/data/models/shared/models/api_error.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';

abstract class ControllerApi {
  static T? nullMapper<T>(_) => null;

  final Dio _dio;

  const ControllerApi(this._dio);

  Future<ApiResponse<T>> delete<T>({
    required String url,
    required T? Function(dynamic) mapper,
  }) async {
    try {
      final response = await _dio.delete(url);

      final result = mapper(response.data);

      return ApiResponse.fromData(result);
    } on DioException catch (e) {
      if (e.response == null) rethrow;

      final error = ApiErrorMapper.fromMap(e.response!.data);
      return ApiResponse.fromError(error);
    }
  }

  Future<ApiResponse<T>> get<T>({
    required String url,
    required T? Function(dynamic) mapper,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: timeout.let((it) => Options(receiveTimeout: it)),
      );

      final result = mapper(response.data);

      return ApiResponse.fromData(result);
    } on DioException catch (e) {
      if (e.response == null) rethrow;

      final error = ApiErrorMapper.fromMap(e.response!.data);
      return ApiResponse.fromError(error);
    }
  }

  Future<ApiResponse<T>> put<T>({
    required String url,
    required T? Function(dynamic) mapper,
    String? data,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        options: timeout.let((it) => Options(receiveTimeout: it)),
      );

      final result = mapper(response.data);

      return ApiResponse.fromData(result);
    } on DioException catch (e) {
      if (e.response == null) rethrow;

      final error = ApiErrorMapper.fromMap(e.response!.data);
      return ApiResponse.fromError(error);
    }
  }

  Future<ApiResponse<T>> post<T>({
    required String url,
    required T? Function(dynamic) mapper,
    dynamic data,
    Duration? timeout,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: timeout.let((it) => Options(receiveTimeout: it)),
      );

      final result = mapper(response.data);

      return ApiResponse.fromData(result);
    } on DioException catch (e) {
      if (e.response == null) rethrow;

      final error = ApiErrorMapper.fromMap(e.response!.data);
      return ApiResponse.fromError(error);
    }
  }
}
