import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLatestPage extends ConsumerWidget {
  const HomeLatestPage({super.key});

  PRestRecipesProvider get provider => pRestRecipesProvider(
    PageableState.recipeLatestFull.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  PPageableStateProvider get pageProvider => pPageableStateProvider(
    PageableState.recipeLatestFull.name,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: FAppBar(title: L10n.of(context).home_latest_page__title),
      body: SafeArea(
        child: FPageable(
          provider: provider,
          pageProvider: pageProvider,
          builder: (_, data) => FWrap(
            children: [
              for (final recipe in data)
                FImageCard.maximized(
                  label: recipe.label,
                  subLabel: recipe.createdOn.toLocalDateString(context),
                  coverSelector: (resolution) => recipe.cover?.url(resolution),
                  width: 400,
                  onTap: () => context.routes.recipesItem(recipe.id),
                ),
            ],
          ),
          onEmpty: FEmptyMessage(
            title: L10n.of(context).home_latest_page__on_empty,
            icon: StateIconConstants.recipes.emptyIcon,
          ),
          onError: FEmptyMessage(
            title: L10n.of(context).home_latest_page__on_error,
            icon: StateIconConstants.recipes.errorIcon,
          ),
        ),
      ),
    );
  }
}
