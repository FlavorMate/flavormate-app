import 'package:flavormate/core/apis/rest/p_dio_private.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/data/datasources/features/recipe_draft_controller_api.dart';
import 'package:flavormate/data/models/features/recipe_draft/recipe_draft_dto.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_rest_recipe_drafts_id.g.dart';

@riverpod
class PRestRecipeDraftsId extends _$PRestRecipeDraftsId {
  @override
  Future<RecipeDraftFullDto> build(String id) async {
    final dio = ref.watch(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final language = currentLocalization().languageCode;

    final response = await client.getRecipeDraftsId(id: id, language: language);

    return response;
  }

  Future<void> delete() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    await client.deleteRecipeDraftsId(id: id);
  }

  Future<void> setDiet(Diet diet) async {
    await setForm({'diet': diet.name});

    ref.invalidateSelf();
    ref.invalidate(pRestRecipeDraftsProvider);
  }

  Future<void> setCourse(Course course) async {
    await setForm({'course': course.name});

    ref.invalidateSelf();
    ref.invalidate(pRestRecipeDraftsProvider);
  }

  Future<ApiResponse<void>> upload() async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    final response = await client.postRecipeDraftsId(id);

    ref.invalidate(pRestRecipesProvider);

    return response;
  }

  Future<void> setForm(Map<String, dynamic> form) async {
    final dio = ref.read(pDioPrivateProvider);

    final client = RecipeDraftControllerApi(dio);

    await client.putRecipeDraftsId(
      id: id,
      form: form,
    );

    ref.invalidateSelf();
    ref.invalidate(pRestRecipeDraftsProvider);
  }
}
