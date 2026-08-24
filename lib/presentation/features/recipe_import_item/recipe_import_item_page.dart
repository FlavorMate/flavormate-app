import 'package:file_selector/file_selector.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/icon_constants.dart';
import 'package:flavormate/core/constants/shape_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_string.dart';
import 'package:flavormate/core/extensions/e_x_type_group.dart';
import 'package:flavormate/core/riverpod/pageable_state/pageable_state.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_wrapper.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers_item.dart';
import 'package:flavormate/data/repositories/features/recipe_drafts/p_rest_recipe_drafts.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/recipe_import_item/recipe_import_item_url_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as path;

class RecipeImportItemPage extends ConsumerStatefulWidget {
  final String id;

  const RecipeImportItemPage({super.key, required this.id});

  PIeImportersItemProvider get provider => pIeImportersItemProvider(id);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeImportItemPageState();
}

class _RecipeImportItemPageState extends ConsumerState<RecipeImportItemPage> {
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
        icon: IconConstants.errorIcon,
      ),
      appBarBuilder: (_, data) => FAppBar(
        title: data.name,
        scrollController: _scrollController,
      ),
      bottomNavigationBarBuilder: (_, data) => Column(
        mainAxisSize: .min,
        spacing: PADDING,
        children: [
          FWrap(
            children: [
              if (data.import.contains(IEImportType.FileImport))
                FButton(
                  leading: const Icon(Symbols.attach_file_add_rounded),
                  tonal: true,
                  width: BUTTON_WIDTH / 2,
                  onPressed: () => addFile(data),
                  label: context.l10n.btn_file,
                ),

              if (data.import.contains(IEImportType.UrlImport))
                FButton(
                  leading: const Icon(Symbols.add_link_rounded),
                  tonal: true,
                  width: BUTTON_WIDTH / 2,
                  onPressed: addUrl,
                  label: context.l10n.btn_web,
                ),
            ],
          ),

          FButton(
            width: BUTTON_WIDTH + PADDING,
            leading: const Icon(Symbols.upload_rounded),
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
                shape: ShapeConstants.secondLevel,
                icon: Symbols.cloud_upload_rounded,
                description: data.importLongDescription,
              ),

              if (urls.isEmpty && files.isEmpty)
                FTileGroup(
                  items: [
                    FTile(
                      label: context.l10n.recipe_import_item_page__on_empty,
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
                        onTap: null,
                        trailing: Padding(
                          padding: const .only(right: 8.0),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => removeUrl(index),
                              child: const Icon(Symbols.close_rounded),
                            ),
                          ),
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
                        trailing: Padding(
                          padding: const .only(right: 8),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => removeFile(index),
                              child: const Icon(Symbols.close_rounded),
                            ),
                          ),
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
      extensions: importer.importExtensions,
      mimeTypes: importer.importMimeTypes,
      uniformTypeIdentifiers: importer.importExtensions
          .map(EXTypeGroup.toUniformTypeIdentifier)
          .toList(),
    );

    final selectedFiles = await openFiles(
      acceptedTypeGroups: [typeGroup],
    );

    setState(() {
      final allowedItems = selectedFiles.where(
        (it) => importer.importExtensions
            .map((it) => it.toLowerCase())
            .contains(path.extension(it.path).toLowerCase()),
      );
      files.addAll(allowedItems);
    });
  }

  void removeFile(int index) {
    setState(() {
      files.removeAt(index);
    });
  }

  void addUrl() async {
    final url = await RecipeImportItemUrlDialog.openDialog(context);

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
        context.l10n.recipe_import_item_page__import_failure,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.recipe_import_item_page__import_success,
      );

      context.pop();
      context.pop();
      context.routes.recipeEditor();
    }
  }
}
