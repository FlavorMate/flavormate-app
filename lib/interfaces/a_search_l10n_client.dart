import 'package:flavormate/interfaces/a_pageable_l10n_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';

abstract class ASearchL10nClient<T> extends APageableL10nClient<T> {
  ASearchL10nClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<T>> findBySearch({
    required String language,
    required String searchTerm,
    int? page,
    int? size,
    String? sortBy,
    String? sortDirection,
  }) async {
    final params = getParams({
      'language': language,
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
