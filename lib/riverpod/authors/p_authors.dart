import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/authors/p_authors_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_authors.g.dart';

@riverpod
class PAuthors extends _$PAuthors {
  @override
  Future<Pageable<Author>> build() async {
    final page = ref.watch(pAuthorsPageProvider);
    return await ref.watch(pApiProvider).authorsClient.findByPage(page: page);
  }
}
