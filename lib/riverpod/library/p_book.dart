import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/library/p_library.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_book.g.dart';

@riverpod
class PBook extends _$PBook {
  @override
  Future<BookWrapper> build(int id) async {
    final user = ref.watch(pUserProvider).requireValue;
    final book = await ref.watch(pApiProvider).libraryClient.findById(id);
    final subscribed = await ref
        .watch(pApiProvider)
        .libraryClient
        .isSubscribed(id);

    return BookWrapper(
      book: book,
      isOwner: user.id! == book.owner.account.id,
      isSubscribed: subscribed,
    );
  }

  Future<bool> toggleSubscription(int id) async {
    await ref.watch(pApiProvider).libraryClient.toggleSubscription(id);
    ref.invalidate(pLibraryProvider);
    ref.invalidateSelf();
    return true;
  }
}

class BookWrapper {
  final Book book;
  final bool isOwner;
  final bool isSubscribed;

  BookWrapper({
    required this.book,
    required this.isOwner,
    required this.isSubscribed,
  });
}
