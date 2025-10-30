import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/categories/p_rest_categories_id.dart';
import 'package:flavormate/data/repositories/features/categories/p_rest_categories_id_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';

class CategoriesItemPage extends StatefulWidget {
  final String id;

  const CategoriesItemPage({required this.id, super.key});

  String get pageProviderId => PageableState.categoryRecipes.getId(id);

  PRestCategoriesIdProvider get provider => pRestCategoriesIdProvider(id);

  PPageableStateProvider get providerRecipePage =>
      pPageableStateProvider(pageProviderId);

  @override
  State<CategoriesItemPage> createState() => _CategoriesItemPageState();
}

class _CategoriesItemPageState extends State<CategoriesItemPage>
    with FOrderMixin<CategoriesItemPage> {
  PRestCategoriesIdRecipesProvider get providerRecipe =>
      pRestCategoriesIdRecipesProvider(
        categoryId: widget.id,
        pageProviderId: widget.pageProviderId,
        orderBy: orderBy,
        orderDirection: orderDirection,
      );

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      appBarBuilder: (_, data) => FAppBar(title: data.label),
      builder: (_, data) => FPageable(
        provider: providerRecipe,
        pageProvider: widget.providerRecipePage,
        filterBuilder: (padding) => FPageableSort(
          currentOrderBy: orderBy,
          currentDirection: orderDirection,
          setOrderBy: setOrderBy,
          setOrderDirection: setOrderDirection,
          options: OrderByConstants.recipe,
          padding: padding,
        ),

        builder: (_, recipes) => FWrap(
          children: [
            for (final recipe in recipes)
              FImageCard.maximized(
                label: recipe.label,
                subLabel: recipe.totalTime.beautify(context),
                coverSelector: (resolution) => recipe.cover?.url(resolution),
                onTap: () => context.routes.recipesItem(recipe.id),
                width: 400,
              ),
          ],
        ),
        onEmpty: FEmptyMessage(
          title: L10n.of(context).categories_item_page__recipe_on_empty,
          icon: StateIconConstants.recipes.emptyIcon,
        ),
        onError: FEmptyMessage(
          title: L10n.of(context).categories_item_page__recipe_on_error,
          icon: StateIconConstants.recipes.errorIcon,
        ),
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).categories_item_page__on_error,
        icon: StateIconConstants.categories.errorIcon,
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
