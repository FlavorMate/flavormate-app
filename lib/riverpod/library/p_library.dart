import 'package:flavormate/extensions/e_string.dart';
import 'package:flavormate/models/library/book.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/library/p_library_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_library.g.dart';

@riverpod
class PLibrary extends _$PLibrary {
  @override
  Future<Pageable<Book>> build() async {
    final page = ref.watch(pLibraryPageProvider);
    final books = await ref
        .watch(pApiProvider)
        .libraryClient
        .findByPage(page: page, sortBy: 'label', sortDirection: 'ASC');

    books.content.sort((a, b) => a.label.compareToIgnoreCase(b.label));

    return books;
  }

  Future<void> createBook(String label) async {
    await ref.read(pApiProvider).libraryClient.create(data: {'label': label});
    ref.invalidateSelf();
  }

  Future<void> toggleVisibility(int id, bool isVisible) async {
    await ref
        .read(pApiProvider)
        .libraryClient
        .update(id, data: {'visible': isVisible});
    ref.invalidateSelf();
  }

  Future<void> updateBook(int id, String label) async {
    await ref
        .read(pApiProvider)
        .libraryClient
        .update(id, data: {'label': label});
    ref.invalidateSelf();
  }

  Future<void> deleteBook(Book book) async {
    await ref.read(pApiProvider).libraryClient.deleteById(book.id!);
    ref.invalidateSelf();
  }
}
