import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/slivers/f_paginated_page/f_paginated_page.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHighlightsPage extends ConsumerWidget {
  const HomeHighlightsPage({super.key});

  PRestHighlightsProvider get provider => pRestHighlightsProvider(
    PageableState.highlightFull.name,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  PPageableStateProvider get pageProvider => pPageableStateProvider(
    PageableState.highlightFull.name,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FPaginatedPage(
      title: L10n.of(context).home_highlights_page__title,
      provider: provider,
      pageProvider: pageProvider,
      onEmpty: FEmptyMessage(
        title: L10n.of(context).home_highlights_page__on_empty,
        icon: StateIconConstants.highlights.emptyIcon,
      ),
      onError: FEmptyMessage(
        title: L10n.of(context).home_highlights_page__on_error,
        icon: StateIconConstants.highlights.errorIcon,
      ),
      itemBuilder: (item) => FImageCard.maximized(
        label: item.recipe.label,
        coverSelector: (resolution) => item.cover?.url(resolution),
        onTap: () => context.routes.recipesItem(item.recipe.id),
        subLabel: item.date.toLocalDateString(context),
      ),
    );
  }
}
