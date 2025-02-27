import 'package:flavormate/components/t_avatar_viewer.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_row.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/author/author.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeAuthor extends StatelessWidget {
  final Author author;

  const RecipeAuthor({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: TColumn(
        children: [
          TText(L10n.of(context).c_recipe_author, TextStyles.headlineMedium),
          OutlinedButton(
            onPressed:
                () => context.pushNamed(
                  'author',
                  pathParameters: {'id': '${author.id}'},
                  extra: author.account.displayName,
                ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
              ),
              padding: const EdgeInsets.all(PADDING / 2),
              minimumSize: const Size(48, 48),
            ),
            child: TRow(
              space: 8,
              children: [
                AvatarViewer(
                  user: author.account,
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
