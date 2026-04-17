import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeImportPage extends ConsumerStatefulWidget {
  const RecipeImportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeImportPageState();
}

class _RecipeImportPageState extends ConsumerState<RecipeImportPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.recipe_import_page__title,
        scrollController: _scrollController,
      ),
      body: SafeArea(
        child: FProviderStruct(
          provider: pIeImportersProvider,
          onError: FEmptyMessage(
            title: context.l10n.recipe_import_page__on_error,
            icon: StateIconConstants.importExport.errorIcon,
          ),
          builder: (context, data) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                FConstrainedBoxSliver(
                  maxWidth: FBreakpoint.smValue,
                  padding: const .all(PADDING),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      FPageIntroductionSliver(
                        shape: .c9_sided_cookie,
                        icon: MdiIcons.databaseImport,
                        description:
                            context.l10n.recipe_import_page__description,
                      ),

                      const FSizedBoxSliver(height: PADDING),

                      if (data.isEmpty)
                        FEmptyMessage(
                          title: context.l10n.recipe_import_page__on_empty,
                          icon: StateIconConstants.importExport.emptyIcon,
                        )
                      else
                        SliverList.separated(
                          itemCount: data.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: PADDING / 4),
                          itemBuilder: (context, index) {
                            final importer = data[index];
                            return FTile.manual(
                              first: index == 0,
                              last: index == data.length - 1,
                              tile: FTile(
                                label: importer.title,
                                subLabel: null,
                                onTap: () {
                                  context.routes.recipeImportItem(importer.id);
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
