import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/recipes/recipe_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class HomeLatestRecipesCarousel extends ConsumerWidget {
  const HomeLatestRecipesCarousel({super.key});

  PRestRecipesProvider get provider => pRestRecipesProvider(
    PageableState.recipeLatestPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listenable = ref.watch(provider);

    final data = listenable.value;

    return FCarousel<RecipePreviewDto>(
      title: context.l10n.home_latest_recipe_carousel__title,
      data: data?.data ?? [],
      loading: listenable.isLoading,
      error: listenable.hasError
          ? context.l10n.home_latest_recipe_carousel__on_error
          : null,
      onTap: (recipe) => context.routes.recipesItem(recipe.id),
      coverSelector: (recipe, resolution) => recipe.cover?.url(resolution),
      labelSelector: (recipe) => recipe.label,
      subLabelSelector: (recipe) =>
          recipe.createdOn.formatter.date.yyyyMMMMdd(context),
      onShowAll: () => context.routes.homeLatest(),
    );
  }
}
