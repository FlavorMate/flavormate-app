import 'package:flavormate/interfaces/a_base_client.dart';
import 'package:flavormate/models/pageable/pageable.dart';

abstract class APageableL10nClient<T> extends ABaseClient<T> {
  APageableL10nClient({
    required super.httpClient,
    required super.baseURL,
    required super.parser,
  });

  Future<Pageable<T>> findByPage({
    required String language,
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
    });

    final response = await httpClient.get('$baseURL/list?$params');

    return Pageable<T>.fromMap(response.data, parser);
  }
}
