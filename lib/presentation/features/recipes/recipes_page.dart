import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
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
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).recipes_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: widget.pageProvider,
          filterBuilder: (padding) => FPageableSort(
            currentOrderBy: orderBy,
            currentDirection: orderDirection,
            setOrderBy: setOrderBy,
            setOrderDirection: setOrderDirection,
            options: OrderByConstants.recipe,
            padding: padding,
          ),
          builder: (_, data) => FWrap(
            children: [
              for (final recipe in data)
                FImageCard.maximized(
                  label: recipe.label,
                  subLabel: recipe.totalTime.beautify(context),
                  coverSelector: (resolution) => recipe.cover?.url(resolution),
                  width: 400,
                  onTap: () => context.routes.recipesItem(recipe.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            icon: StateIconConstants.recipes.emptyIcon,
            title: L10n.of(context).recipes_page__on_empty,
          ),
          onError: FEmptyMessage(
            icon: StateIconConstants.recipes.errorIcon,
            title: L10n.of(context).recipes_page__on_error,
          ),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
