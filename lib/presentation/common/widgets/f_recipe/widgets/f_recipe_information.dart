import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeInformation extends StatelessWidget {
  final Course course;
  final Diet diet;

  const FRecipeInformation({
    super.key,
    required this.course,
    required this.diet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          L10n.of(context).f_recipe_information__title,
          style: FTextStyle.headlineMedium,
          weight: FontWeight.w500,
        ),
        Wrap(
          runSpacing: PADDING,
          spacing: PADDING,
          children: [
            Chip(avatar: Icon(diet.icon), label: Text(diet.getName(context))),
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
