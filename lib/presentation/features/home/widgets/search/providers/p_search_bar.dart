import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/riverpod/delayed_provider/delayed_provider.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/account_controller_api.dart';
import 'package:flavormate/data/datasources/features/book_controller_api.dart';
import 'package:flavormate/data/datasources/features/category_controller_api.dart';
import 'package:flavormate/data/datasources/features/recipe_controller_api.dart';
import 'package:flavormate/data/datasources/features/tag_controller_api.dart';
import 'package:flavormate/data/models/shared/models/search_result.dart';
import 'package:flavormate/presentation/features/home/widgets/search/providers/p_search_bar_value.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search_bar.g.dart';

@riverpod
class PSearchBar extends _$PSearchBar with DebounceProvider {
  static const int _pageSize = 6;
  static const int _page = 0;

  @override
  Future<List<SearchResult>> build() async {
    final search = ref.watch(pSearchBarValueProvider);
    final dio = ref.watch(pDioPrivateProvider);

    debounce(ref);

    if (search.length < 3) return [];

    final accounts = await _fetchAccounts(dio, search);
    final books = await _fetchBooks(dio, search);
    final categories = await _fetchCategories(dio, search);
    final recipes = await _fetchRecipes(dio, search);
    final tags = await _fetchTags(dio, search);

    return [
      ...accounts,
      ...books,
      ...categories,
      ...recipes,
      ...tags,
    ].sorted((a, b) => a.label.length.compareTo(b.label.length));
  }

  Future<List<SearchResult>> _fetchAccounts(
    Dio dio,
    String search,
  ) async {
    final client = AccountControllerApi(dio);

    final accounts = await client.getAccountsSearch(
      query: search,
      page: _page,
      pageSize: _pageSize,
    );

    return accounts.data
        .map(
          (account) => SearchResult(
            type: SearchResultType.author,
            label: account.displayName,
            id: account.id,
          ),
        )
        .toList();
  }

  Future<List<SearchResult>> _fetchBooks(
    Dio dio,
    String search,
  ) async {
    final client = BookControllerApi(dio);

    final books = await client.getBooksSearch(
      query: search,
      page: _page,
      pageSize: _pageSize,
    );

    return books.data
        .map(
          (book) => SearchResult(
            type: SearchResultType.book,
            label: book.label,
            id: book.id,
          ),
        )
        .toList();
  }

  Future<List<SearchResult>> _fetchCategories(
    Dio dio,
    String search,
  ) async {
    final language = currentLocalization().languageCode;
    final client = CategoryControllerApi(dio);
    final categories = await client.getCategoriesSearch(
      query: search,
      language: language,
      page: _page,
      pageSize: _pageSize,
    );

    return categories.data
        .map(
          (category) => SearchResult(
            type: SearchResultType.category,
            label: category.label,
            id: category.id,
          ),
        )
        .toList();
  }

  Future<List<SearchResult>> _fetchRecipes(
    Dio dio,
    String search,
  ) async {
    final client = RecipeControllerApi(dio);

    final recipes = await client.getRecipesSearch(
      query: search,
      page: _page,
      pageSize: _pageSize,
    );

    return recipes.data
        .map(
          (category) => SearchResult(
            type: SearchResultType.recipe,
            label: category.label,
            id: category.id,
          ),
        )
        .toList();
  }

  Future<List<SearchResult>> _fetchTags(
    Dio dio,
    String search,
  ) async {
    final client = TagControllerApi(dio);

    final tags = await client.getTagsSearch(
      query: search,
      page: _page,
      pageSize: _pageSize,
    );

    return tags.data
        .map(
          (tag) => SearchResult(
            type: SearchResultType.tag,
            id: tag.id,
            label: tag.label,
          ),
        )
        .toList();
  }
}
