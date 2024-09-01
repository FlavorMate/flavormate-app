import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_date_time.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePublished extends StatelessWidget {
  final DateTime createdOn;
  final Uri? url;
  final int version;

  const RecipePublished({
    super.key,
    required this.createdOn,
    required this.url,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return TColumn(
      children: [
        TText(L10n.of(context).c_recipe_published, TextStyles.headlineMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(createdOn.toLocalDateString(context)),
            Text('${L10n.of(context).c_recipe_published_version}: $version'),
          ],
        ),
        if (url != null)
          OutlinedButton(
            onPressed: () => launchUrl((url!)),
            child: Text(L10n.of(context).c_recipe_published_origin),
          ),
      ],
    );
  }
}
