import 'package:file_selector/file_selector.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_wrapper.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers_item.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/recipe_import_item/recipe_import_item_url_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeImportItemPage extends ConsumerStatefulWidget {
  final String id;

  const RecipeImportItemPage({super.key, required this.id});

  PIeImportersItemProvider get provider => pIeImportersItemProvider(id);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeImportItemPageState();
}

class _RecipeImportItemPageState extends ConsumerState<RecipeImportItemPage> {
  static const _width = 125.0;

  final _scrollController = ScrollController();

  final List<String> urls = [];
  final List<XFile> files = [];

  bool get _importValid => files.isNotEmpty || urls.isNotEmpty;

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
        title: context.l10n.recipe_import_item_page__on_error,
        icon: MdiIcons.download,
      ),
      appBarBuilder: (_, data) => FAppBar(
        title: data.title,
        scrollController: _scrollController,
      ),
      bottomNavigationBarBuilder: (_, data) => Column(
        mainAxisSize: .min,
        spacing: PADDING,
        children: [
          FWrap(
            children: [
              if (data.import.contains(IEImportType.FileImport))
                SizedBox(
                  width: _width,
                  child: FCard(
                    color: context.colorScheme.primaryContainer,
                    onTap: () => addFile(data),
                    child: Row(
                      children: [
                        const Icon(MdiIcons.filePlus),
                        Expanded(
                          child: Center(child: Text(context.l10n.btn_file)),
                        ),
                      ],
                    ),
                  ),
                ),

              if (data.import.contains(IEImportType.UrlImport))
                SizedBox(
                  width: _width,
                  child: FCard(
                    color: context.colorScheme.primaryContainer,
                    onTap: addUrl,
                    child: Row(
                      children: [
                        const Icon(MdiIcons.webPlus),
                        Expanded(
                          child: Center(child: Text(context.l10n.btn_web)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          FButton(
            width: _width * 2 + PADDING,
            leading: const Icon(MdiIcons.upload),
            label: context.l10n.btn_import,
            onPressed: _importValid ? () => import(data.id) : null,
          ),
        ],
      ),
      builder: (context, data) {
        return FResponsive(
          controller: _scrollController,
          child: Column(
            spacing: PADDING,
            children: [
              FPageIntroduction(
                shape: .sunny,
                icon: MdiIcons.cloudUpload,
                description: data.desc,
              ),

              if (urls.isEmpty && files.isEmpty)
                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.recipe_import_item_page__on_empty,
                      subLabel: null,
                      onTap: null,
                    ),
                  ],
                ),

              if (urls.isNotEmpty)
                FTileGroup(
                  title: context.l10n.recipe_import_item_page__urls,
                  items: [
                    for (final (index, url) in urls.indexed)
                      FTile(
                        label: url,
                        subLabel: null,
                        onTap: null,
                        trailing: IconButton(
                          onPressed: () => removeUrl(index),
                          icon: const Icon(MdiIcons.close),
                        ),
                      ),
                  ],
                ),
              if (files.isNotEmpty)
                FTileGroup(
                  title: context.l10n.recipe_import_item_page__files,
                  items: [
                    for (final (index, file) in files.indexed)
                      FTile(
                        label: file.name,
                        subLabel: null,
                        onTap: null,
                        trailing: IconButton(
                          onPressed: () => removeFile(index),
                          icon: const Icon(MdiIcons.close),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  void addFile(IEMetadata importer) async {
    final typeGroup = XTypeGroup(
      extensions: importer.supportedExtensions,
      mimeTypes: importer.supportedMimeTypes,
    );

    final selectedFiles = await openFiles(
      acceptedTypeGroups: [typeGroup],
    );

    setState(() {
      files.addAll(selectedFiles);
    });
  }

  void removeFile(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  void addUrl() async {
    final url = await showDialog<String>(
      context: context,
      builder: (context) => const RecipeImportItemUrlDialog(),
    );

    if (!context.mounted || url.isBlank) return;

    setState(() {
      urls.add(url!);
    });
  }

  void removeUrl(int index) {
    setState(() {
      urls.removeAt(index);
    });
  }

  void import(String pluginId) async {
    context.showLoadingDialog();

    final provider = pRestRecipeDraftsProvider(PageableState.recipeDrafts.name);

    final data = IEImportWrapper(
      pluginId: pluginId,
      files: files,
      urls: urls,
    );

    final response = await ref.read(provider.notifier).import(data);

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_editor_page__import_success,
      );

      context.pop();
      context.pop();
      context.routes.recipeEditor();
    }
  }
}
