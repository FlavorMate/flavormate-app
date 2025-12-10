import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flutter/material.dart';

class HomeStoriesCarousel extends StatelessWidget {
  const HomeStoriesCarousel({super.key});

  PRestStoriesProvider get provider => pRestStoriesProvider(
    PageableState.storiesPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context) {
    return FProviderStruct(
      provider: provider,
      builder: (_, stories) => stories.data.isNotEmpty
          ? FCarousel(
              title: context.l10n.home_stories_carousel__title,
              data: stories.data,
              onTap: (story) => context.routes.storiesItem(story.id),
              coverSelector: (story, resolution) =>
                  story.cover?.url(resolution),
              labelSelector: (story) => story.label,
              onShowAll: () => context.routes.homeStories(),
            )
          : const SizedBox.shrink(),
      onError: FEmptyMessage(
        title: context.l10n.home_stories_carousel__on_error,
        icon: StateIconConstants.stories.errorIcon,
      ),
    );
  }
}
