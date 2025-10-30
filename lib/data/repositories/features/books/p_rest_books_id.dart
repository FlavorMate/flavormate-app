import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/book_controller_api.dart';
import 'package:flavormate/data/models/features/books/book_dto.dart';
import 'package:flavormate/data/models/features/books/book_update_dto.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id_subscriber.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_books_id.g.dart';

@riverpod
class PRestBooksId extends _$PRestBooksId {
  @override
  Future<BookDto> build({
    required String bookId,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    return await client.getBooksId(bookId: bookId);
  }

  Future<ApiResponse<void>> subscribeToBook() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.putBooksIdSubscriber(
      id: bookId,
    );

    if (!response.hasError) {
      ref.invalidateSelf();
      ref.invalidate(pRestBooksProvider);
      ref.invalidate(pRestBooksIdSubscriberProvider);
    }

    return response;
  }

  Future<ApiResponse<void>> setVisibility(bool visible) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.putBooksId(
      id: bookId,
      form: BookUpdateDto(visible: visible),
    );

    if (!response.hasError) {
      ref.invalidateSelf();
      ref.invalidate(pRestBooksProvider);
    }

    return response;
  }

  Future<ApiResponse<void>> setLabel(String label) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.putBooksId(
      id: bookId,
      form: BookUpdateDto(label: label),
    );

    if (!response.hasError) {
      ref.invalidateSelf();
      ref.invalidate(pRestBooksProvider);
    }

    return response;
  }

  Future<ApiResponse<void>> deleteBook() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    final response = await client.deleteBooksId(id: bookId);

    if (!response.hasError) {
      ref.invalidate(pRestBooksProvider);
    }

    return response;
  }
}
