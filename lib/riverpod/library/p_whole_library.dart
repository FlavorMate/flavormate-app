import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/library/p_library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_whole_library.g.dart';

@riverpod
class PWholeLibrary extends _$PWholeLibrary {
  @override
  Future<List<Book>> build() async {
    return await ref.watch(pApiProvider).libraryClient.findOwn();
  }

  Future toggleRecipeInBook(int bookId, int recipeId) async {
    await ref
        .read(pApiProvider)
        .libraryClient
        .toggleRecipeInBook(bookId, recipeId);

    ref.invalidate(pLibraryProvider);
    ref.invalidateSelf();
  }
}
