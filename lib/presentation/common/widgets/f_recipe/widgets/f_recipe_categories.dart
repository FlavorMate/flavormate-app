import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_category.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeCategories extends StatelessWidget {
  final bool readOnly;
  final List<CommonCategory> categories;

  const FRecipeCategories({
    super.key,
    required this.readOnly,
    required this.categories,
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

        Wrap(
          spacing: PADDING,
          runSpacing: PADDING,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
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
