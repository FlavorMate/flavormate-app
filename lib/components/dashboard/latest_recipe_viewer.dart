import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_slide.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/riverpod/recipes/p_latest_recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LatestRecipeViewer extends ConsumerWidget {
  const LatestRecipeViewer({
    super.key,
  });

  TSlide getSlide(BuildContext context, Recipe recipe) => TSlide(
        imageSrc: recipe.coverUrl,
        title: recipe.label,
        date: recipe.createdOn,
        onTap: () => context.pushNamed(
          'recipe',
          pathParameters: {'id': '${recipe.id}'},
          extra: recipe.label,
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pLatestRecipesProvider);
    return TCard(
      padding: 4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TText(
              L10n.of(context).c_dashboard_latest,
              TextStyles.displaySmall,
              color: TextColor.onPrimaryContainer,
            ),
          ),
          RStruct(
            provider,
            (_, highlights) => TCarousel(
              height: 400,
              slides:
                  highlights.content.map((l) => getSlide(context, l)).toList(),
            ),
            loadingChild: const SizedBox(
              height: 400,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
