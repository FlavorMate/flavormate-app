import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/contents/f_paginated_content_card.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.recipes.name);
}

class _RecipesPageState extends State<RecipesPage>
    with FOrderMixin<RecipesPage> {
  PRestRecipesProvider get provider => pRestRecipesProvider(
    PageableState.recipes.name,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: context.l10n.recipes_page__title,
      pageProvider: widget.pageProvider,
      provider: provider,
      onEmpty: FEmptyMessage(
        icon: StateIconConstants.recipes.emptyIcon,
        title: context.l10n.recipes_page__on_empty,
      ),
      onError: FEmptyMessage(
        icon: StateIconConstants.recipes.errorIcon,
        title: context.l10n.recipes_page__on_error,
      ),
      sortBuilder: () => FPaginatedSort(
        currentOrderBy: orderBy,
        currentDirection: orderDirection,
        setOrderBy: setOrderBy,
        setOrderDirection: setOrderDirection,
        options: OrderByConstants.recipe,
      ),
      itemBuilder: (items) => FPaginatedContentCard(
        data: items,
        itemBuilder: (item) => FImageCard.maximized(
          coverSelector: (resolution) => item.cover?.url(resolution),
          subLabel: item.totalTime.beautify(context),
          label: item.label,
          onTap: () => context.routes.recipesItem(item.id),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
