import 'package:file_picker/file_picker.dart';
import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_export_wrapper.dart';
import 'package:flavormate/data/models/shared/enums/order_by.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_exporters_item.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/data/repositories/features/recipes/p_rest_recipes.dart';
import 'package:flavormate/presentation/common/mixins/f_order_mixin.dart';
import 'package:flavormate/presentation/common/slivers/f_constrained_box_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_lazy_sliver_list.dart';
import 'package:flavormate/presentation/common/slivers/f_page_introduction_sliver.dart';
import 'package:flavormate/presentation/common/slivers/f_sized_box_sliver.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeExportItemPage extends ConsumerStatefulWidget {
  final String id;

  const RecipeExportItemPage({super.key, required this.id});

  PIeExportersItemProvider get provider => pIeExportersItemProvider(id);

  String get recipePageId => PageableState.recipeExport.name;

  PPageableStateProvider get recipePageProvider =>
      pPageableStateProvider(recipePageId);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeExportItemPageState();
}

class _RecipeExportItemPageState extends ConsumerState<RecipeExportItemPage>
    with FOrderMixin {
  static const _width = 125.0;

  final _scrollController = ScrollController();

  final List<String> _selected = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      onError: FEmptyMessage(
        title: context.l10n.recipe_export_item_page__on_error,
        icon: MdiIcons.download,
      ),
      appBarBuilder: (_, data) => FAppBar(
        title: data.name,
        scrollController: _scrollController,
      ),
      bottomNavigationBarBuilder: (_, data) => Padding(
        padding: const EdgeInsets.only(top: PADDING),
        child: Align(
          heightFactor: 1,
          child: FButton(
            width: _width * 2 + PADDING,
            leading: const Icon(MdiIcons.download),
            label: context.l10n.btn_download,
            onPressed: _selected.isNotEmpty ? () => export(data.id) : null,
          ),
        ),
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
                    shape: .sunny,
                    icon: MdiIcons.cloudDownload,
                    description: data.exportLongDescription,
                  ),

                  const FSizedBoxSliver(height: PADDING),

                  FLazySliverList(
                    key: orderKey,
                    provider: pRestRecipesProvider(
                      widget.recipePageId,
                      orderBy: orderBy,
                      orderDirection: orderDirection,
                    ),
                    pageProvider: widget.recipePageProvider,
                    scrollController: _scrollController,
                    itemBuilder: (data, index, first, last) {
                      final selected = _selected.contains(data.id);
                      return FTile.manual(
                        first: first,
                        last: last,
                        tile: FTile(
                          leading: Icon(
                            selected
                                ? MdiIcons.checkCircle
                                : MdiIcons.circleOutline,
                          ),
                          label: data.label,
                          subLabel: null,
                          onTap: () {
                            setState(() {
                              if (!_selected.remove(data.id)) {
                                _selected.add(data.id);
                              }
                            });
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
    );
  }

  void export(String pluginId) async {
    context.showLoadingDialog();

    final provider = pRestRecipeDraftsProvider(PageableState.recipeDrafts.name);

    final data = IEExportWrapper(
      pluginId: pluginId,
      recipeIds: _selected,
    );

    final response = await ref.read(provider.notifier).export(data);

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_export_item_page__export_failure,
      );
      return;
    }

    bool shareResult;
    try {
      await FilePicker.saveFile(
        fileName: response.data!.fileName,
        bytes: response.data!.bytes,
      );
      shareResult = true;
    } catch (e) {
      shareResult = false;
    }

    if (!mounted) return;
    if (!shareResult) {
      context.showTextSnackBar(
        context.l10n.recipe_export_item_page__export_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_export_item_page__export_success,
      );

      context.pop();
      context.pop();
    }
  }

  @override
  OrderBy get defaultOrderBy => .Label;
}
