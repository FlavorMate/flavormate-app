import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/categories/p_rest_categories.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(PageableState.categories.name);

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage>
    with FOrderMixin<CategoriesPage> {
  PRestCategoriesProvider get provider => pRestCategoriesProvider(
    PageableState.categories.name,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).categories_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: widget.pageProvider,
          filterBuilder: (padding) => FPageableSort(
            currentOrderBy: orderBy,
            currentDirection: orderDirection,
            setOrderBy: setOrderBy,
            setOrderDirection: setOrderDirection,
            options: OrderByConstants.category,
            padding: padding,
          ),
          builder: (_, data) => FWrap(
            children: [
              for (final category in data)
                FImageCard.maximized(
                  label: category.label,
                  coverSelector: (resolution) =>
                      category.cover?.url(resolution),
                  subLabel: L10n.of(context).categories_page__recipe_counter(
                    category.recipeCount,
                  ),
                  onTap: () => context.routes.categoriesItem(category.id),
                  width: 400,
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).categories_page__on_empty,
            icon: StateIconConstants.categories.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).categories_page__on_error,
            icon: StateIconConstants.categories.errorIcon,
          ),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
