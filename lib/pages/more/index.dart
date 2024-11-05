import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TResponsive(
      child: TColumn(
        children: [
          TCard(
            child: Wrap(
              direction: Axis.vertical,
              spacing: PADDING,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TText(
                  L10n.of(context).p_more_title,
                  TextStyles.headlineMedium,
                ),
                TIconButton(
                  width: 250,
                  onPressed: () => context.pushNamed('categories'),
                  icon: MdiIcons.archive,
                  label: L10n.of(context).p_more_categories,
                ),
                TIconButton(
                  width: 250,
                  onPressed: () => context.pushNamed('tags'),
                  icon: MdiIcons.tag,
                  label: L10n.of(context).p_more_tags,
                ),
              ],
            ),
          ),
          TCard(
            child: Wrap(
              direction: Axis.vertical,
              spacing: PADDING,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TText(
                  L10n.of(context).p_more_title_more,
                  TextStyles.headlineMedium,
                ),
                TIconButton(
                  width: 250,
                  onPressed: () => context.pushNamed('drafts'),
                  icon: MdiIcons.bookPlus,
                  label: L10n.of(context).p_more_recipes,
                ),
                TIconButton(
                  width: 250,
                  onPressed: () => context.pushNamed('storyDrafts'),
                  icon: MdiIcons.newspaperVariantOutline,
                  label: L10n.of(context).p_more_stories,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
