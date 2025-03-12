import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/categories/category.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PublicRecipeCategories extends StatelessWidget {
  final List<Category> categories;

  const PublicRecipeCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TText(L10n.of(context).c_recipe_categories, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        Wrap(
          spacing: PADDING,
          runSpacing: PADDING,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children:
              categories
                  .map((category) => Chip(label: Text(category.label)))
                  .toList(),
        ),
      ],
    );
  }
}
