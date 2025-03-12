import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/categories/p_raw_categories.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreviewCategories extends ConsumerWidget {
  const PreviewCategories({super.key, required this.categories});

  final List<int> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pRawCategoriesProvider);
    return Column(
      children: [
        TText(L10n.of(context).c_recipe_categories, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        RStruct(
          provider,
          (_, categoryMap) => Wrap(
            spacing: PADDING,
            runSpacing: PADDING,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            children:
                categories
                    .map(
                      (category) =>
                          Chip(label: Text(categoryMap[category]!.label)),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
