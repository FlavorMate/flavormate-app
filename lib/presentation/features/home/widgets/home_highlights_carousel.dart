import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flutter/material.dart';

class HomeHighlightsCarousel extends StatelessWidget {
  const HomeHighlightsCarousel({super.key});

  PRestHighlightsProvider get provider => pRestHighlightsProvider(
    PageableState.highlightPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      builder: (context, highlights) => highlights.data.isNotEmpty
          ? FCarousel(
              title: L10n.of(context).home_highlights_carousel__title,
              data: highlights.data,
              onTap: (highlight) =>
                  context.routes.recipesItem(highlight.recipe.id),
              coverSelector: (highlight, resolution) =>
                  highlight.cover?.url(resolution),
              labelSelector: (highlight) => highlight.recipe.label,
              subLabelSelector: (highlight) =>
                  highlight.date.toLocalDateString(context),
              onShowAll: () => context.routes.homeHighlights(),
            )
          : const SizedBox.shrink(),

      onError: FEmptyMessage(
        title: L10n.of(context).home_highlights_carousel__on_error,
        icon: StateIconConstants.highlights.errorIcon,
      ),
    );
  }
}
