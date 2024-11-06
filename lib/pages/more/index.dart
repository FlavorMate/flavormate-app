import 'package:flavormate/components/riverpod/r_feature.dart';
import 'package:flavormate/components/t_card.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_icon_button.dart';
import 'package:flavormate/components/t_responsive.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/features/p_feature_story.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyProvider = ref.watch(pFeatureStoryProvider);
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
                  onPressed: () => context.pushNamed('recipe-drafts'),
                  icon: MdiIcons.bookPlus,
                  label: L10n.of(context).p_more_recipes,
                ),
                RFeature(
                  storyProvider,
                  (_) => TIconButton(
                    width: 250,
                    onPressed: () => context.pushNamed('story-drafts'),
                    icon: MdiIcons.newspaperVariantOutline,
                    label: L10n.of(context).p_more_stories,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
