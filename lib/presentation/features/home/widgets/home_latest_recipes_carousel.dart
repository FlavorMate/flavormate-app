import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flutter/material.dart';

class HomeLatestRecipesCarousel extends StatelessWidget {
  const HomeLatestRecipesCarousel({super.key});

  PRestRecipesProvider get provider => pRestRecipesProvider(
    PageableState.recipeLatestPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      builder: (_, recipes) => recipes.data.isNotEmpty
          ? FCarousel(
              title: L10n.of(context).home_latest_recipe_carousel__title,
              data: recipes.data,
              onTap: (recipe) => context.routes.recipesItem(recipe.id),
              coverSelector: (recipe, resolution) =>
                  recipe.cover?.url(resolution),
              labelSelector: (recipe) => recipe.label,
              subLabelSelector: (recipe) =>
                  recipe.createdOn.toLocalDateString(context),
              onShowAll: () => context.routes.homeLatest(),
            )
          : const SizedBox.shrink(),
      onError: FEmptyMessage(
        title: L10n.of(context).home_latest_recipe_carousel__on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
    );
  }
}
