import 'package:flavormate/components/t_circular_avatar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';

class PublicRecipeAuthor extends StatelessWidget {
  final Author author;

  const PublicRecipeAuthor({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TColumn(
        children: [
          TText(L10n.of(context).c_recipe_author, TextStyles.headlineMedium),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
              ),
              padding: const EdgeInsets.all(PADDING / 2),
              minimumSize: const Size(48, 48),
            ),
            child: TRow(
              mainAxisSize: MainAxisSize.min,
              space: 8,
              children: [
                TCircularAvatar(
                  label: author.account.displayName,
                  height: 28,
                  width: 28,
                  fontSize: 12,
                  borderRadius: 8,
                ),
                Text(author.account.displayName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
