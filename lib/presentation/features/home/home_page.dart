import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/features/home/widgets/home_highlights_carousel.dart';
import 'package:flavormate/presentation/features/home/widgets/home_latest_recipes_carousel.dart';
import 'package:flavormate/presentation/features/home/widgets/home_quick_actions.dart';
import 'package:flavormate/presentation/features/home/widgets/home_stories_carousel.dart';
import 'package:flavormate/presentation/features/home/widgets/search/home_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyEnabled = ref.watch(pFeatureStoryProvider);

    return FResponsive(
      maxWidth: FBreakpoint.xlValue,
      child: Column(
        spacing: PADDING,
        children: [
          const HomeSearchBar(),
          const HomeQuickActions(),
          if (storyEnabled) const HomeStoriesCarousel(),
          const HomeHighlightsCarousel(),
          const HomeLatestRecipesCarousel(),
        ],
      ),
    );
  }
}
