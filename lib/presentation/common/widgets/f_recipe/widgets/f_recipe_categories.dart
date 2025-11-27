import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_category.dart';
import 'package:flavormate/data/models/shared/enums/course.dart';
import 'package:flavormate/data/models/shared/enums/diet.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flutter/material.dart';

class FRecipeCategories extends StatelessWidget {
  final bool readOnly;
  final List<CommonCategory> categories;
  final Course course;
  final Diet diet;

  const FRecipeCategories({
    super.key,
    required this.readOnly,
    required this.categories,
    required this.course,
    required this.diet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          L10n.of(context).f_recipe_categories__title,
          style: FTextStyle.headlineMedium,
          weight: FontWeight.w500,
        ),

        FWrap(
          children: [
            Chip(avatar: Icon(diet.icon), label: Text(diet.getName(context))),
            Chip(
              avatar: Icon(course.icon),
              label: Text(course.getName(context)),
            ),
          ],
        ),

        FWrap(
          children: [
            for (final category in categories)
              ActionChip(
                label: Text(category.label),
                onPressed: readOnly
                    ? () {}
                    : () => context.routes.categoriesItem(category.id),
              ),
          ],
        ),
      ],
    );
  }
}
