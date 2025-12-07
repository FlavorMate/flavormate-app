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
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesItemPage extends ConsumerStatefulWidget {
  final String id;

  const CategoriesItemPage({required this.id, super.key});

  String get pageProviderId => PageableState.categoryRecipes.getId(id);

  PRestCategoriesIdProvider get provider => pRestCategoriesIdProvider(id);

  PPageableStateProvider get providerRecipePage =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<CategoriesItemPage> createState() => _CategoriesItemPageState();
}

class _CategoriesItemPageState extends ConsumerState<CategoriesItemPage>
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
    final category = ref.watch(widget.provider);
    return FPaginatedPage(
      title: category.value?.label ?? '',
      provider: providerRecipe,
      pageProvider: widget.providerRecipePage,
      onEmpty: FEmptyMessage(
        title: L10n.of(context).categories_item_page__recipe_on_empty,
        icon: StateIconConstants.recipes.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).categories_item_page__recipe_on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.recipe,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.label,
        subLabel: item.totalTime.beautify(context),
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.recipesItem(item.id),
        width: 400,
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
