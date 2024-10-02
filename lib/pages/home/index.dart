import 'package:flavormate/components/dashboard/highlights_viewer.dart';
import 'package:flavormate/components/dashboard/latest_recipe_viewer.dart';
import 'package:flavormate/components/dashboard/quick_actions.dart';
import 'package:flavormate/components/dashboard/stories_viewer.dart';
import 'package:flavormate/components/riverpod/r_feature.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_search.dart';
import 'package:flavormate/riverpod/features/p_feature_story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyProvider = ref.watch(pFeatureStoryProvider);
    return TResponsive(
      child: TColumn(
        children: [
          TSearch(),
          QuickActions(),
          RFeature(storyProvider, (_) => StoriesViewer()),
          HighlightsViewer(),
          LatestRecipeViewer(),
        ],
      ),
    );
  }
}
