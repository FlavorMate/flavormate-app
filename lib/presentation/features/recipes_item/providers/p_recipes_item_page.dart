import 'package:flavormate/core/config/features/p_feature_bring.dart';
import 'package:flavormate/core/config/features/p_feature_share.dart';
import 'package:flavormate/data/models/local/common_recipe/common_recipe.dart';
import 'package:flavormate/data/models/shared/models/api_response.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes_id.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_unit_conversions.dart';
import 'package:flavormate/presentation/features/recipes_item/models/p_recipe_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'p_recipes_item_page.g.dart';

@riverpod
class PRecipesItemPage extends _$PRecipesItemPage {
  @override
  Future<PRecipePageWrapper> build(String id) async {
    await ref.watch(pRestUnitConversionsProvider.future);
    final recipe = await ref.watch(pRestRecipesIdProvider(id).future);
    final user = await ref.watch(pRestAccountsSelfProvider.future);
    final isBringEnabled = ref.watch(pFeatureBringProvider);
    final isShareEnabled = ref.watch(pFeatureShareProvider);

    return PRecipePageWrapper(
      recipe: CommonRecipe.fromRecipe(recipe),
      isBringEnabled: isBringEnabled,
      isShareEnabled: isShareEnabled,
      isOwner: recipe.ownedBy.id == user.id,
      isAdmin: user.isAdmin,
    );
  }

  Future<ApiResponse<void>> transferRecipe(
    String accountId,
    String newOwner,
  ) async {
    return await ref
        .read(pRestRecipesIdProvider(id).notifier)
        .transferRecipe(accountId, newOwner);
  }

  Future<ApiResponse<bool>> delete() async {
    return await ref.read(pRestRecipesIdProvider(id).notifier).deleteRecipe();
  }

  Future<ApiResponse<String>> editRecipe() async {
    return await ref.read(pRestRecipesIdProvider(id).notifier).editRecipe();
  }

  Future<ApiResponse<String>> shareRecipe() async {
    return await ref.read(pRestRecipesIdProvider(id).notifier).shareRecipe();
  }
}
