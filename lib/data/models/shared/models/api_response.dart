import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/data/models/shared/models/api_error.dart';

part 'api_response.mapper.dart';

@MappableClass()
class ApiResponse<T> with ApiResponseMappable {
  final T? data;
  final ApiError? error;

  bool get hasData => data != null;

  bool get hasError => error != null;

  const ApiResponse(this.data, this.error);

  factory ApiResponse.fromData(T? data) {
    return ApiResponse<T>(data, null);
  }

  factory ApiResponse.fromError(ApiError error) {
    return ApiResponse<T>(null, error);
  }
}
