import 'package:flavormate/models/categories/category_group.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_category_groups.g.dart';

@riverpod
class PCategoryGroups extends _$PCategoryGroups {
  @override
  Future<List<CategoryGroup>> build() async {
    final language = currentLocalization().languageCode;
    return await ref
        .watch(pApiProvider)
        .categoryGroupClient
        .findAll(language: language);
  }
}
