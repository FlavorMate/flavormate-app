import 'package:flavormate/clients/api_client.dart';
import 'package:flavormate/models/appLink/app_link.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/utils/u_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_public_recipe.g.dart';

@riverpod
class PPublicRecipe extends _$PPublicRecipe {
  @override
  Future<Recipe> build(AppLink appLink) async {
    final language = currentLocalization().languageCode;

    final api = ApiClient.public(appLink.server);

    return await api.publicRecipeClient.findByIdL10n(
      appLink.token,
      appLink.id,
      language,
    );
  }
}
