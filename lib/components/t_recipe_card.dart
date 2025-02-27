import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const TRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 450,
      child: TCard(
        padding: 0,
        onTap:
            () => context.pushNamed(
              'recipe',
              pathParameters: {'id': recipe.id.toString()},
              extra: recipe.label,
            ),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                child: TImage(
                  imageSrc: recipe.coverUrl,
                  type: TImageType.network,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(PADDING),
              child: TColumn(
                space: PADDING / 2,
                children: [
                  TText(recipe.label, TextStyles.headlineMedium),
                  Row(
                    children: [
                      Text(
                        recipe.tags!
                            .getRange(
                              0,
                              recipe.tags!.length >= 2
                                  ? 2
                                  : recipe.tags!.length,
                            )
                            .map((tag) => tag.label)
                            .join(' - '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
