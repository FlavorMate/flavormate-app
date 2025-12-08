import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
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
    final user = ref.watch(pRestAccountsSelfProvider);

    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.flavormate,
        automaticallyImplyLeading: false,
        showHome: false,
      ),
      body: FResponsive(
        child: Column(
          crossAxisAlignment: .start,
          spacing: PADDING,
          children: [
            FTileGroup(
              title: context.l10n.more_page__recipes,
              items: [
                FTile(
                  label: context.l10n.more_page__categories,
                  subLabel: context.l10n.more_page__categories_hint,
                  icon: MdiIcons.package,
                  iconColor: .blue,
                  onTap: () => context.routes.categories(),
                ),
                FTile(
                  label: context.l10n.more_page__tags,
                  subLabel: context.l10n.more_page__tags_hint,
                  icon: MdiIcons.tag,
                  iconColor: .lightBlue,
                  onTap: () => context.routes.tags(),
                ),
              ],
            ),
            FTileGroup(
              title: context.l10n.more_page__editors,
              items: [
                FTile(
                  label: context.l10n.more_page__recipe_editor,
                  subLabel: context.l10n.more_page__recipe_editor_hint,
                  icon: MdiIcons.bookPlus,
                  iconColor: .red,
                  onTap: () => context.routes.recipeEditor(),
                ),
                if (storiesEnabled)
                  FTile(
                    label: context.l10n.more_page__story_editor,
                    subLabel: context.l10n.more_page__story_editor_hint,
                    icon: MdiIcons.newspaperVariantOutline,
                    iconColor: .orange,
                    onTap: () => context.routes.storyEditor(),
                  ),
              ],
            ),
            if (user.value?.isAdmin == true)
              FTileGroup(
                title: context.l10n.more_page__admin_title,
                items: [
                  FTile(
                    label: context.l10n.more_page__admin_account_management,
                    subLabel:
                        context.l10n.more_page__admin_account_management_hint,
                    icon: MdiIcons.accountGroup,
                    iconColor: .yellow,
                    onTap: () =>
                        context.routes.administrationAccountManagement(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
