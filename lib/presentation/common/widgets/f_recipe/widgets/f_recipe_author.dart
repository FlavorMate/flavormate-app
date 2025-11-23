import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';

class FRecipeAuthor extends StatelessWidget {
  final bool readOnly;
  final AccountDto account;

  const FRecipeAuthor({
    super.key,
    required this.account,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: WIDGET_WIDTH),
      child: Column(
        spacing: PADDING,
        children: [
          FText(
            L10n.of(context).f_recipe_author__title,
            style: FTextStyle.headlineMedium,
            weight: .w500,
          ),
          OutlinedButton(
            onPressed: readOnly
                ? () {}
                : () => context.routes.accountsItem(account.id),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
              ),
              padding: const EdgeInsets.all(PADDING / 2),
              minimumSize: const Size(48, 48),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                FCircularAvatarViewer(
                  account: account,
                  height: 28,
                  width: 28,
                  borderRadius: 8,
                ),
                Text(account.displayName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
