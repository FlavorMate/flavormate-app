import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesEnabled = ref.watch(pFeatureStoryProvider);

    return Scaffold(
      appBar: FAppBar(
        title: L10n.of(context).flavormate,
        automaticallyImplyLeading: false,
        showHome: false,
      ),
      body: FResponsive(
        child: Column(
          crossAxisAlignment: .start,
          spacing: PADDING,
          children: [
            FTileGroup(
              title: L10n.of(context).more_page__recipes,
              items: [
                FTile(
                  onTap: () => context.routes.categories(),
                  icon: MdiIcons.archive,
                  label: L10n.of(context).more_page__categories,
                ),
                FTile(
                  onTap: () => context.routes.tags(),
                  icon: MdiIcons.tag,
                  label: L10n.of(context).more_page__tags,
                ),
              ],
            ),
            FTileGroup(
              title: L10n.of(context).more_page__editors,
              items: [
                FTile(
                  onTap: () => context.routes.recipeEditor(),
                  icon: MdiIcons.bookPlus,
                  label: L10n.of(context).more_page__recipe_editor,
                ),
                if (storiesEnabled)
                  FTile(
                    onTap: () => context.routes.storyEditor(),
                    icon: MdiIcons.newspaperVariantOutline,
                    label: L10n.of(context).more_page__story_editor,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
