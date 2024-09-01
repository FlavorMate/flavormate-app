import 'package:flavormate/interfaces/a_pageable_client.dart';
import 'package:flavormate/models/highlight.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/models/recipe/diet.dart';

class HighlightsClient extends APageableClient<Highlight> {
  HighlightsClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<Highlight>> findAllByDiet({
    int? page,
    int? size,
    String? sortBy,
    String? sortDirection,
    required Diet filter,
  }) async {
    final params = getParams({
      'size': size,
      'sortBy': sortBy,
      'sortDirection': sortDirection,
      'page': page,
    });

    final response =
        await httpClient.get('$baseURL/list/${filter.name}?$params');

    HighlightMapper.fromMap(response.data!['content'][0]);

    return Pageable.fromMap(response.data!, parser);
  }
}
