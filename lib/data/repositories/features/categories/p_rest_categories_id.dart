import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/category_controller_api.dart';
import 'package:flavormate/data/models/features/categories/category_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_categories_id.g.dart';

@riverpod
class PRestCategoriesId extends _$PRestCategoriesId {
  @override
  Future<CategoryDto> build(String categoryId) async {
    final language = currentLocalization().languageCode;

    final dio = ref.watch(pDioPrivateProvider);

    final client = CategoryControllerApi(dio);

    final response = await client.getCategoriesId(
      id: categoryId,
      language: language,
    );

    return response;
  }
}
