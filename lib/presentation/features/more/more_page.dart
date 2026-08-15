import 'package:flavormate/core/config/features/p_feature_export.dart';
import 'package:flavormate/core/config/features/p_feature_import.dart';
import 'package:flavormate/core/config/features/p_feature_story.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/features/accounts/p_rest_accounts_self.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesEnabled = ref.watch(pFeatureStoryProvider);
    final importEnabled = ref.watch(pFeatureImportProvider);
    final exportEnabled = ref.watch(pFeatureExportProvider);
    final user = ref.watch(pRestAccountsSelfProvider).requireValue;

    return Scaffold(
      appBar: FAppBar(
        scrollController: null,
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
                  leading: const FTileIcon(icon: Symbols.inventory_2_rounded),
                  onTap: () => context.routes.categories(),
                ),
                FTile(
                  label: context.l10n.more_page__tags,
                  subLabel: context.l10n.more_page__tags_hint,
                  leading: const FTileIcon(icon: Symbols.sell_rounded),
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
                  leading: const FTileIcon(icon: Symbols.cake_add_rounded),
                  onTap: () => context.routes.recipeEditor(),
                ),
                if (storiesEnabled)
                  FTile(
                    label: context.l10n.more_page__story_editor,
                    subLabel: context.l10n.more_page__story_editor_hint,
                    leading: const FTileIcon(icon: Symbols.chat_add_on_rounded),
                    onTap: () => context.routes.storyEditor(),
                  ),
              ],
            ),

            if ((user.canExport && exportEnabled) ||
                (user.canImport && importEnabled))
              FTileGroup(
                title: context.l10n.more_page__import_export__title,
                items: [
                  if (importEnabled)
                    FTile(
                      label:
                          context.l10n.more_page__import_export__import_title,
                      subLabel: context
                          .l10n
                          .more_page__import_export__import_description,
                      leading: const FTileIcon(
                        icon: Symbols.cloud_upload_rounded,
                      ),
                      onTap: () => context.routes.recipeImport(),
                    ),

                  if (exportEnabled)
                    FTile(
                      label:
                          context.l10n.more_page__import_export__export_title,
                      subLabel: context
                          .l10n
                          .more_page__import_export__export_description,
                      leading: const FTileIcon(
                        icon: Symbols.cloud_download_rounded,
                      ),
                      onTap: () => context.routes.recipeExport(),
                    ),
                ],
              ),
            if (user.isAdmin == true)
              FTileGroup(
                title: context.l10n.more_page__admin_title,
                items: [
                  FTile(
                    label: context.l10n.more_page__admin_account_management,
                    subLabel:
                        context.l10n.more_page__admin_account_management_hint,
                    leading: const FTileIcon(icon: Symbols.group_rounded),
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
