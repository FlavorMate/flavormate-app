import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_carousel.dart';
import 'package:flavormate/components/t_empty_message.dart';
import 'package:flavormate/components/t_image.dart';
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
        type: TImageType.network,
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
          SizedBox(
            height: 60,
            child: Center(
              child: TText(
                L10n.of(context).c_dashboard_latest,
                TextStyles.displaySmall,
                color: TextColor.onPrimaryContainer,
              ),
            ),
          ),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: RStruct(
              provider,
              (_, latestRecipes) => latestRecipes.page.empty
                  ? TEmptyMessage(
                      title:
                          L10n.of(context).c_dashboard_latest_recipes_no_title,
                      subtitle: L10n.of(context)
                          .c_dashboard_latest_recipes_no_subtitle,
                    )
                  : TCarousel(
                      height: 400,
                      slides: latestRecipes.content
                          .map((l) => getSlide(context, l))
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
