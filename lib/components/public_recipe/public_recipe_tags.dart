import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/tag/tag.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PublicRecipeTags extends StatelessWidget {
  final List<Tag> tags;

  const PublicRecipeTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TText(L10n.of(context).c_recipe_tags, TextStyles.headlineMedium),
        const SizedBox(height: PADDING),
        Wrap(
          spacing: PADDING,
          runSpacing: PADDING,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: tags
              .map((category) => Chip(label: Text(category.label)))
              .toList(),
        ),
      ],
    );
  }
}
