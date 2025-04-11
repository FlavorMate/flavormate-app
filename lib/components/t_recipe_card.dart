import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_content_card.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_duration.dart';
import 'package:flavormate/models/recipe/recipe.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class TRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const TRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return TContentCard(
      onTap:
          () => context.pushNamed(
            'recipe',
            pathParameters: {'id': recipe.id.toString()},
            extra: recipe.label,
          ),
      content: TText(
        recipe.label,
        TextStyles.headlineSmall,
        color: TextColor.white,
        textOverflow: TextOverflow.ellipsis,
      ),
      contentHeight: 24,
      header: [
        Row(
          spacing: PADDING / 2,
          children: [
            Icon(MdiIcons.clockOutline, color: Colors.white),
            TText(
              recipe.totalTime.beautify(context),
              TextStyles.labelLarge,
              color: TextColor.white,
            ),
          ],
        ),
        Row(
          spacing: PADDING / 2,
          children: [
            Icon(recipe.diet.icon, color: Colors.white),
            TText(
              recipe.diet.getName(context),
              TextStyles.labelLarge,
              color: TextColor.white,
            ),
          ],
        ),
      ],
      emptyIcon: MdiIcons.foodOffOutline,
      imageUrl: recipe.coverUrl,
    );
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
