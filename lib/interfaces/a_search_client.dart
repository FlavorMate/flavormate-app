import 'package:flavormate/interfaces/a_pageable_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';

abstract class ASearchClient<T> extends APageableClient<T> {
  ASearchClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<T>> findBySearch({
    required String searchTerm,
    int? page,
    int? size,
    String? sortBy,
    String? sortDirection,
  }) async {
    final params = getParams({
      'size': size,
      'sortBy': sortBy,
      'sortDirection': sortDirection,
      'page': page,
      'searchTerm': searchTerm,
    });

    final response = await httpClient.get('$baseURL/search?$params');

    return Pageable.fromMap(response.data!, parser);
  }
}
