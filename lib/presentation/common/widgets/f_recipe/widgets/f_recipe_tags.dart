import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/local/common_recipe/common_tag.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeTags extends StatelessWidget {
  final bool readOnly;
  final List<CommonTag> tags;

  const FRecipeTags({super.key, required this.readOnly, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FText(
          L10n.of(context).f_recipe_tags__title,
          style: FTextStyle.headlineMedium,
          weight: FontWeight.w500,
        ),
        const SizedBox(height: PADDING),
        Wrap(
          spacing: PADDING,
          runSpacing: PADDING,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          children: [
            for (final tag in tags)
              ActionChip(
                label: Text('#${tag.label}'),
                onPressed: readOnly
                    ? () {}
                    : () => context.routes.tagsItem(tag.id),
              ),
          ],
        ),
      ],
    );
  }
}
