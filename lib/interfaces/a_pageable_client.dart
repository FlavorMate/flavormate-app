import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';

abstract class APageableClient<T> extends ABaseClient<T> {
  APageableClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<T>> findByPage({
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
    });

    final response = await httpClient.get('$baseURL/list?$params');

    return Pageable<T>.fromMap(response.data, parser);
  }
}
