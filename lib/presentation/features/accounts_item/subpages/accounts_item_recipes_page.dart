import 'package:flavormate/core/constants/order_by_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_recipes.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_sort.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsItemRecipesPage extends ConsumerStatefulWidget {
  final String id;

  const AccountsItemRecipesPage({super.key, required this.id});

  String get pageProviderId => PageableState.accountRecipes.getId(id);

  PPageableStateProvider get pageProvider =>
      pPageableStateProvider(pageProviderId);

  @override
  ConsumerState<AccountsItemRecipesPage> createState() =>
      _AccountsItemRecipesPageState();
}

class _AccountsItemRecipesPageState
    extends ConsumerState<AccountsItemRecipesPage>
    with FOrderMixin<AccountsItemRecipesPage> {
  PRestAccountsIdRecipesProvider get provider => pRestAccountsIdRecipesProvider(
    accountId: widget.id,
    pageProviderId: widget.pageProviderId,
    orderBy: orderBy,
    orderDirection: orderDirection,
  );

  @override
  Widget build(BuildContext context) {
    return FPaginatedPage(
      title: context.l10n.accounts_item_recipe_page__title,
      provider: provider,
      pageProvider: widget.pageProvider,
      onEmpty: FEmptyMessage(
        title: context.l10n.accounts_item_recipe_page__on_empty,
        icon: StateIconConstants.recipes.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: context.l10n.accounts_item_recipe_page__on_error,
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
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.recipesItem(item.id),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
