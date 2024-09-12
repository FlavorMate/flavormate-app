import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/category_group/p_category_groups.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_draft_categories.g.dart';

@riverpod
class PDraftCategories extends _$PDraftCategories {
  @override
  Future<Map<String, List<Category>>> build() async {
    final language = currentLocalization().languageCode;
    final Map<String, List<Category>> map = {};

    final categoryGroups =
        await ref.watch(pCategoryGroupsProvider.selectAsync((data) => data));
    final categories =
        await ref.watch(pApiProvider).categoriesClient.findRaw(language);

    for (final categoryGroup in categoryGroups) {
      map[categoryGroup.label] = categories
          .where((category) => category.group.id == categoryGroup.id)
          .toList();
    }

    return map;
  }
}
