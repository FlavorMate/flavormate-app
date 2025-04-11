import 'package:flavormate/components/t_content_card.dart';
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
      emptyIcon: MdiIcons.foodOutline,
      imageUrl: recipe.coverUrl,
    );
  }
}
