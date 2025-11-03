import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id.dart';
import 'package:flavormate/data/repositories/features/books/p_rest_books_id_subscriber.dart';
import 'package:flavormate/presentation/features/library_item/models/library_item_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_library_item.g.dart';

@riverpod
class PLibraryItem extends _$PLibraryItem {
  PRestBooksIdProvider get _parentProvider =>
      pRestBooksIdProvider(bookId: bookId);

  @override
  Future<LibraryItemWrapper> build(String bookId) async {
    final book = await ref.watch(_parentProvider.future);
    final isSubscribed = await ref.watch(
      pRestBooksIdSubscriberProvider(bookId: bookId).future,
    );
    final user = await ref.watch(pRestAccountsSelfProvider.future);

    return LibraryItemWrapper(
      book: book,
      isOwner: book.ownedBy.id == user.id,
      isAdmin: user.isAdmin,
      isSubscribed: isSubscribed,
    );
  }

  Future<ApiResponse<void>> subscribeToBook() async {
    return await ref.read(_parentProvider.notifier).subscribeToBook();
  }

  Future<ApiResponse<void>> setVisibility(bool visible) async {
    return await ref.read(_parentProvider.notifier).setVisibility(visible);
  }

  Future<ApiResponse<void>> setLabel(String label) async {
    return await ref.read(_parentProvider.notifier).setLabel(label);
  }

  Future<ApiResponse<void>> deleteBook() async {
    return await ref.read(_parentProvider.notifier).deleteBook();
  }
}
