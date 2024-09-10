import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_raw_categories.g.dart';

@riverpod
class PRawCategories extends _$PRawCategories {
  @override
  Future<Map<int, Category>> build() async {
    final language = currentLocalization().languageCode;
    final categories =
        await ref.watch(pApiProvider).categoriesClient.findRaw(language);

    return {for (var v in categories) v.id!: v};
  }
}
