import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_date_time.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FRecipePublished extends StatelessWidget {
  final DateTime createdOn;
  final String? url;
  final int version;

  const FRecipePublished({
    super.key,
    required this.createdOn,
    required this.url,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: PADDING,
      children: [
        FText(
          L10n.of(context).f_recipe_published__title,
          style: FTextStyle.headlineMedium,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(createdOn.toLocalDateString(context)),
            Text('${L10n.of(context).f_recipe_published__version}: $version'),
          ],
        ),
        if (url != null)
          OutlinedButton(
            onPressed: () => launchUrl(Uri.parse(url!)),
            child: Text(L10n.of(context).f_recipe_published__open_original),
          ),
      ],
    );
  }
}
