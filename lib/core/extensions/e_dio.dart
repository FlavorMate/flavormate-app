import 'package:dio/dio.dart';

extension EDio on Dio {
  Future<List<T>> getList<T>(
    String url,
    T Function(DioObjectResponse) mapper,
  ) async {
    final response = await get<List<dynamic>>(url);

    final list = List<DioObjectResponse>.from(response.data!);

    return list.map(mapper).toList();
  }

  Future<T> getObject<T>(
    String url,
    T Function(DioObjectResponse) mapper,
  ) async {
    final response = await get<DioObjectResponse>(url);

    final data = mapper.call(response.data!);

    return data;
  }

  Future<T> postObject<T>(
    String url,
    T Function(DioObjectResponse) mapper, {
    String? json,
  }) async {
    final response = await post<DioObjectResponse>(url, data: json);

    final data = mapper.call(response.data!);

    return data;
  }
}

extension EResponse on Response {
  bool get isOK =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

typedef DioObjectResponse = Map<String, dynamic>;
