import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_struct.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class RecipeExportPage extends ConsumerStatefulWidget {
  const RecipeExportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeExportPageState();
}

class _RecipeExportPageState extends ConsumerState<RecipeExportPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).listTheme.cardList;
    return Scaffold(
      appBar: FAppBar(
        title: context.l10n.recipe_export_page__title,
        scrollController: _scrollController,
      ),
      body: SafeArea(
        child: FProviderStruct(
          provider: pIeExportersProvider,
          onError: FEmptyMessage(
            title: context.l10n.recipe_export_page__on_error,
            icon: IconConstants.errorIcon,
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
                        shape: ShapeConstants.firstLevel,
                        icon: Symbols.cloud_download_rounded,
                        description:
                            context.l10n.recipe_export_page__description,
                      ),

                      const FSizedBoxSliver(height: PADDING),

                      if (data.isEmpty)
                        FEmptyMessage(
                          title: context.l10n.recipe_export_page__on_empty,
                          icon: IconConstants.emptyIcon,
                        )
                      else
                        SliverList.separated(
                          itemCount: data.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: theme.gap),
                          itemBuilder: (context, index) {
                            final exporter = data[index];
                            return FTile.manual(
                              first: index == 0,
                              last: index == data.length - 1,
                              context: context,
                              tile: FTile(
                                leading: const FTileIcon(
                                  icon: Symbols.extension_rounded,
                                ),
                                label: exporter.name,
                                subLabel: exporter.exportShortDescription,
                                onTap: () => context.routes.recipeExportItem(
                                  exporter.id,
                                ),
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
