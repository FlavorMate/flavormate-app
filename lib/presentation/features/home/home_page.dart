import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/features/home/widgets/home_app_bar.dart';
import 'package:flavormate/presentation/features/home/widgets/home_highlights_carousel.dart';
import 'package:flavormate/presentation/features/home/widgets/home_latest_recipes_carousel.dart';
import 'package:flavormate/presentation/features/home/widgets/home_quick_actions.dart';
import 'package:flavormate/presentation/features/home/widgets/home_stories_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyEnabled = ref.watch(pFeatureStoryProvider);
    final account = ref.watch(pRestAccountsSelfProvider);

    return CustomScrollView(
      slivers: [
        const FSizedBoxSliver(height: PADDING),
        SliverPadding(
          padding: const .symmetric(horizontal: PADDING),
          sliver: FConstrainedBoxSliver(
            maxWidth: FBreakpoint.mdValue,
            sliver: HomeAppBar(account: account.value),
          ),
        ),
        const FSizedBoxSliver(height: PADDING),
        SliverPadding(
          padding: const .only(left: PADDING, right: PADDING, bottom: PADDING),
          sliver: FConstrainedBoxSliver(
            maxWidth: FBreakpoint.mdValue,
            sliver: SliverList.list(
              children: [
                const HomeQuickActions(),
                if (storyEnabled) const HomeStoriesCarousel(),
                const HomeHighlightsCarousel(),
                const HomeLatestRecipesCarousel(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
