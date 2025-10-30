import 'package:dart_mappable/dart_mappable.dart';

part 'api_error.mapper.dart';

@MappableClass()
class ApiError with ApiErrorMappable {
  final String request;
  final int statusCode;
  final String statusText;
  final String message;
  final String? id;

  const ApiError(
    this.request,
    this.statusCode,
    this.statusText,
    this.message,
    this.id,
  );
}
