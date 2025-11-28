import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/data/models/features/accounts/account_dto.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/dialogs/f_confirm_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_circular_avatar_viewer.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FRecipePublished extends StatelessWidget {
  static const double _buttonWidth = 250;
  final AccountDto account;
  final bool readOnly;
  final DateTime createdOn;
  final String? url;
  final int version;

  const FRecipePublished({
    super.key,
    required this.account,
    required this.readOnly,
    required this.createdOn,
    required this.url,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .max,
      spacing: PADDING,
      children: [
        FText(
          L10n.of(context).f_recipe_published__title,
          style: FTextStyle.headlineMedium,
          weight: FontWeight.w500,
        ),
        OutlinedButton(
          onPressed: readOnly
              ? () {}
              : () => context.routes.accountsItem(account.id),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BORDER_RADIUS),
            ),
            padding: const EdgeInsets.all(PADDING / 1.25),
            minimumSize: const Size(_buttonWidth, 48),
            maximumSize: const Size(_buttonWidth, double.infinity),
          ),
          child: Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              FCircularAvatarViewer(
                account: account,
                height: 32,
                width: 32,
                borderRadius: 8,
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  FText(
                    account.displayName,
                    style: .titleMedium,
                    color: .primary,
                    weight: .bold,
                  ),
                  Text(createdOn.toLocalDateString(context)),
                ],
              ),
            ],
          ),
        ),

        if (url != null)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(_buttonWidth, 48),
              maximumSize: const Size(_buttonWidth, double.infinity),
            ),
            onPressed: () => _openRecipeSource(context),
            child: Text(L10n.of(context).f_recipe_published__open_original),
          ),
      ],
    );
  }

  void _openRecipeSource(BuildContext context) async {
    final response = await showDialog(
      context: context,
      builder: (_) => FConfirmDialog(
        title: L10n.of(context).f_recipe_published__open_original_warning_title,
        content: L10n.of(
          context,
        ).f_recipe_published__open_original_warning(url!),
      ),
    );

    if (response != true) return;

    launchUrl(Uri.parse(url!),mode: LaunchMode.externalApplication);
  }
}
