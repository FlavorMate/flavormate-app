import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_icon_button.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesEnabled = ref.watch(pFeatureStoryProvider);
    return Column(
      children: [
        FAppBar(title: L10n.of(context).flavormate),
        Expanded(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FCard(
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: PADDING,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FText(
                        L10n.of(context).more_page__recipes,
                        style: FTextStyle.headlineMedium,
                        weight: FontWeight.w500,
                      ),
                      FIconButton(
                        width: 250,
                        onPressed: () => context.routes.categories(),
                        icon: MdiIcons.archive,
                        label: L10n.of(context).more_page__categories,
                      ),
                      FIconButton(
                        width: 250,
                        onPressed: () => context.routes.tags(),
                        icon: MdiIcons.tag,
                        label: L10n.of(context).more_page__tags,
                      ),
                    ],
                  ),
                ),
                FCard(
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: PADDING,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FText(
                        L10n.of(context).more_page__more,
                        style: FTextStyle.headlineMedium,
                        weight: .w500,
                      ),
                      FIconButton(
                        width: 250,
                        onPressed: () => context.routes.recipeEditor(),
                        icon: MdiIcons.bookPlus,
                        label: L10n.of(context).more_page__recipe_editor,
                      ),
                      if (storiesEnabled)
                        FIconButton(
                          width: 250,
                          onPressed: () => context.routes.storyEditor(),
                          icon: MdiIcons.newspaperVariantOutline,
                          label: L10n.of(context).more_page__story_editor,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
