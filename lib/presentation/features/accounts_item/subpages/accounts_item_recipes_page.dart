import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_id_recipes.dart';
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
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).accounts_item_recipe_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: widget.pageProvider,
          filterBuilder: (padding) => FPageableSort(
            currentOrderBy: orderBy,
            currentDirection: orderDirection,
            setOrderBy: setOrderBy,
            setOrderDirection: setOrderDirection,
            options: const [OrderBy.Label, OrderBy.CreatedOn],
            padding: padding,
          ),
          builder: (_, recipes) => FWrap(
            children: [
              for (final recipe in recipes)
                FImageCard.maximized(
                  label: recipe.label,
                  coverSelector: (resolution) => recipe.cover?.url(resolution),
                  width: 400,
                  onTap: () => context.routes.recipesItem(recipe.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).accounts_item_recipe_page__on_empty,
            icon: StateIconConstants.recipes.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).accounts_item_recipe_page__on_error,
            icon: StateIconConstants.recipes.errorIcon,
          ),
        ),
      ),
    );
  }

  @override
  OrderBy get defaultOrderBy => OrderBy.Label;
}
