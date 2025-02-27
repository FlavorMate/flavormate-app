import 'package:flavormate/models/search/search_result.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/features/p_feature_story.dart';
import 'package:flavormate/riverpod/search/p_search_term.dart';
import 'package:flavormate/riverpod/user/p_user.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_search.g.dart';

@riverpod
class PSearch extends _$PSearch {
  @override
  Future<List<SearchResult>> build() async {
    final language = currentLocalization().languageCode;
    final term = ref.watch(pSearchTermProvider);
    if (term.length < 3) return [];
    // We capture whether the provider is currently disposed or not.
    var didDispose = false;
    ref.onDispose(() => didDispose = true);

    // We delay the request by 1000ms, to wait for the user to stop refreshing.
    await Future<void>.delayed(const Duration(milliseconds: 1000));

    // If the provider was disposed during the delay, it means that the user
    // refreshed again. We throw an exception to cancel the request.
    // It is safe to use an exception here, as it will be caught by Riverpod.
    if (didDispose) {
      throw Exception('Cancelled');
    }

    final user = await ref.read(pUserProvider.selectAsync((data) => data));

    final recipeResponses = (await ref
        .read(pApiProvider)
        .recipesClient
        .findBySearch(
          searchTerm: term,
          filter: user.diet!,
          sortBy: 'label',
        )).content.map(
      (recipe) => SearchResult(
        type: SearchResultType.recipe,
        label: recipe.label,
        id: recipe.id!,
      ),
    );

    final bookResponses = (await ref
        .read(pApiProvider)
        .libraryClient
        .findBySearch(searchTerm: term, sortBy: 'label')).content.map(
      (book) => SearchResult(
        type: SearchResultType.book,
        label: book.label,
        id: book.id!,
      ),
    );

    final authorResponses = (await ref
        .read(pApiProvider)
        .authorsClient
        .findBySearch(
          searchTerm: term,
          sortBy: 'account.displayName',
        )).content.map(
      (author) => SearchResult(
        type: SearchResultType.author,
        label: author.account.displayName,
        id: author.id!,
      ),
    );

    final categoryResponses = (await ref
        .read(pApiProvider)
        .categoriesClient
        .findBySearch(
          language: language,
          searchTerm: term,
          sortBy: 'label',
        )).content.map(
      (category) => SearchResult(
        type: SearchResultType.category,
        label: category.label,
        id: category.id!,
      ),
    );

    var storiesResponses = <SearchResult>[];
    if (ref.read(pFeatureStoryProvider).requireValue) {
      storiesResponses =
          (await ref
                  .read(pApiProvider)
                  .storiesClient
                  .findBySearch(searchTerm: term, sortBy: 'label')).content
              .map(
                (story) => SearchResult(
                  type: SearchResultType.story,
                  label: story.label,
                  id: story.id!,
                ),
              )
              .toList();
    }

    final tagsResponses = (await ref
        .read(pApiProvider)
        .tagsClient
        .findBySearch(searchTerm: term, sortBy: 'label')).content.map(
      (tag) => SearchResult(
        type: SearchResultType.tag,
        label: tag.label,
        id: tag.id!,
      ),
    );

    final responses = [
      ...authorResponses,
      ...bookResponses,
      ...categoryResponses,
      ...recipeResponses,
      ...storiesResponses,
      ...tagsResponses,
    ];
    responses.sort((a, b) => a.label.length - b.label.length);
    return responses;
  }
}
