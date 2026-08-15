import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/highlights/highlight_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/highlights/p_rest_highlights.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class HomeHighlightsCarousel extends ConsumerWidget {
  const HomeHighlightsCarousel({super.key});

  PRestHighlightsProvider get provider => pRestHighlightsProvider(
    PageableState.highlightPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listenable = ref.watch(provider);

    final data = listenable.value;

    return FCarousel<HighlightDto>(
      title: context.l10n.home_highlights_carousel__title,
      data: data?.data ?? [],
      loading: listenable.isLoading,
      error: listenable.hasError
          ? context.l10n.home_highlights_carousel__on_error
          : null,
      onTap: (highlight) => context.routes.recipesItem(highlight.recipe.id),
      coverSelector: (highlight, resolution) =>
          highlight.cover?.url(resolution),
      labelSelector: (highlight) => highlight.recipe.label,
      subLabelSelector: (highlight) =>
          highlight.date.formatter.date.yyyyMMMMdd(context),
      onShowAll: () => context.routes.homeHighlights(),
    );
  }
}
