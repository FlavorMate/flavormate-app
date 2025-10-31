import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/book_controller_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_books_id_subscriber.g.dart';

@riverpod
class PRestBooksIdSubscriber extends _$PRestBooksIdSubscriber {
  @override
  Future<bool> build({
    required String bookId,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    return await client.getBooksIdSubscriber(bookId: bookId);
  }
}
