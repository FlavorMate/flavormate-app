import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_whole_library.g.dart';

@riverpod
class PWholeLibrary extends _$PWholeLibrary {
  @override
  Future<Pageable<Book>> build() async {
    return await ref.watch(pApiProvider).libraryClient.findByPage(
          page: 0,
          size: -1,
          sortBy: 'label',
          sortDirection: 'ASC',
        );
  }

  Future toggleRecipeInBook(int bookId, int recipeId) async {
    await ref
        .read(pApiProvider)
        .libraryClient
        .toggleRecipeInBook(bookId, recipeId);

    ref.invalidateSelf();
  }
}
