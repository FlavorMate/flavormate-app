import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/features/stories/story_dto.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/models/shared/enums/order_direction.dart';
import 'package:flavormate/data/repositories/features/stories/p_rest_stories.dart';
import 'package:flavormate/presentation/common/widgets/f_carousel/f_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class HomeStoriesCarousel extends ConsumerWidget {
  const HomeStoriesCarousel({super.key});

  PRestStoriesProvider get provider => pRestStoriesProvider(
    PageableState.storiesPreview.name,
    pageSize: 14,
    orderBy: OrderBy.CreatedOn,
    orderDirection: OrderDirection.Descending,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listenable = ref.watch(provider);

    final data = listenable.value;

    return FCarousel<StoryPreviewDto>(
      title: context.l10n.home_stories_carousel__title,
      data: data?.data ?? [],
      loading: listenable.isLoading,
      error: listenable.hasError
          ? context.l10n.home_stories_carousel__on_error
          : null,
      onTap: (story) => context.routes.storiesItem(story.id),
      coverSelector: (story, resolution) => story.cover?.url(resolution),
      labelSelector: (story) => story.label,
      onShowAll: () => context.routes.homeStories(),
    );
  }
}
