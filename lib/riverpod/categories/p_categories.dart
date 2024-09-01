import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/categories/p_categories_page.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_categories.g.dart';

@riverpod
class PCategories extends _$PCategories {
  @override
  Future<Pageable<Category>> build() async {
    final language = currentLocalization().languageCode;
    final page = ref.watch(pCategoriesPageProvider);
    return await ref.watch(pApiProvider).categoriesClient.findNotEmpty(
          language: language,
          page: page,
          sortBy: 'label',
          sortDirection: 'ASC',
        );
  }
}
