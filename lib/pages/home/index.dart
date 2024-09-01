import 'package:flavormate/components/dashboard/highlights_viewer.dart';
import 'package:flavormate/components/dashboard/latest_recipe_viewer.dart';
import 'package:flavormate/components/dashboard/quick_actions.dart';
import 'package:flavormate/components/dashboard/stories_viewer.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TResponsive(
      child: TColumn(
        children: [
          TSearch(),
          QuickActions(),
          StoriesViewer(),
          HighlightsViewer(),
          LatestRecipeViewer(),
        ],
      ),
    );
  }
}
