import 'package:flavormate/interfaces/a_pageable_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/diet.dart';

abstract class AFilterSearchClient<T> extends APageableClient<T> {
  AFilterSearchClient({
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
    Diet? filter,
  }) async {
    final params = getParams({
      'searchTerm': searchTerm,
      'size': size,
      'sortBy': sortBy,
      'sortDirection': sortDirection,
      'page': page,
      'filter': filter?.name,
    });

    final response = await httpClient.get('$baseURL/search?$params');

    return Pageable.fromMap(response.data!, parser);
  }
}
