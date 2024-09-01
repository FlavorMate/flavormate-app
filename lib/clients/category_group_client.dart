import 'package:dio/dio.dart';
import 'package:flavormate/models/categories/category_group.dart';
import 'package:flutter/foundation.dart';

class CategoryGroupClient {
  @protected
  final Dio httpClient;
  @protected
  final String baseURL;
  @protected
  final CategoryGroup Function(Map<String, dynamic>) parser;

  CategoryGroupClient({
    required this.httpClient,
    required this.baseURL,
    required this.parser,
  });

  Future<List<CategoryGroup>> findAll({required String language}) async {
    final response =
        await httpClient.get<List<dynamic>>('$baseURL/?language=$language');

    List<Map<String, dynamic>> data = List.from(response.data!);

    return data.map(parser).toList();
  }

  Future<CategoryGroup> findById(int id) async {
    final response = await httpClient.get('$baseURL/$id');
    return parser(response.data);
  }
}
