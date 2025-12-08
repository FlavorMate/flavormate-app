import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLatestPage extends ConsumerWidget {
  const HomeLatestPage({super.key});

  PRestRecipesProvider get provider => pRestRecipesProvider(
    PageableState.recipeLatestFull.name,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  PPageableStateProvider get pageProvider => pPageableStateProvider(
    PageableState.recipeLatestFull.name,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FPaginatedPage(
      title: context.l10n.home_latest_page__title,
      provider: provider,
      pageProvider: pageProvider,
      onEmpty: FEmptyMessage(
        title: context.l10n.home_latest_page__on_empty,
        icon: StateIconConstants.recipes.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: context.l10n.home_latest_page__on_error,
        icon: StateIconConstants.recipes.errorIcon,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.label,
        subLabel: item.createdOn.toLocalDateString(context),
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.recipesItem(item.id),
      ),
    );
  }
}
