import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/data/datasources/features/book_controller_api.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_books_id_subscribers.g.dart';

@riverpod
class PRestBooksIdSubscribers extends _$PRestBooksIdSubscribers {
  @override
  Future<PageableDto<AccountPreviewDto>> build({
    required String bookId,
  }) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = BookControllerApi(dio);

    return await client.getBooksIdSubscribers(bookId: bookId);
  }
}
