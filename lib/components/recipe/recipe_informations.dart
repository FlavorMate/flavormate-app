import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/recipe/course.dart';
import 'package:flavormate/models/recipe/diet.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class RecipeInformations extends StatelessWidget {
  final Course course;
  final Diet diet;

  const RecipeInformations({
    super.key,
    required this.course,
    required this.diet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TText(
            L10n.of(context).c_recipe_informations, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        Wrap(
          runSpacing: PADDING,
          spacing: PADDING,
          children: [
            Chip(
              avatar: Icon(diet.icon),
              label: Text(diet.getName(context)),
            ),
            Chip(
              avatar: Icon(course.icon),
              label: Text(course.getName(context)),
            ),
          ],
        ),
      ],
    );
  }
}
