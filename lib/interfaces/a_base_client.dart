import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class ABaseClient<T> {
  @protected
  final Dio httpClient;
  @protected
  final String baseURL;
  @protected
  final T Function(Map<String, dynamic>) parser;

  ABaseClient({
    required this.httpClient,
    required this.baseURL,
    required this.parser,
  });

  Future<List<T>> findAll() async {
    final response = await httpClient.get<List<dynamic>>('$baseURL/');

    List<Map<String, dynamic>> data = List.from(response.data!);

    return data.map(parser).toList();
  }

  Future<T> findById(int id) async {
    final response = await httpClient.get('$baseURL/$id');
    return parser(response.data);
  }

  Future<T> create({required Map<String, dynamic> data}) async {
    final response = await httpClient.post('$baseURL/', data: data);
    return parser(response.data);
  }

  Future<T> update(int id, {required Map<String, dynamic> data}) async {
    final response = await httpClient.put('$baseURL/$id', data: data);
    return parser(response.data);
  }

  Future<bool> deleteById(int id) async {
    final response = await httpClient.delete<bool>('$baseURL/$id');
    return response.data!;
  }

  @protected
  String getParams(Map<String, dynamic> params) {
    return params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent("${entry.value}")}')
        .join('&');
  }
}
