import 'package:file_selector/file_selector.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_import_type.dart';
import 'package:flavormate/data/models/extensions/importExport/ie_metadata.dart';
import 'package:flavormate/data/repositories/extension/import_export/p_ie_importers.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/recipe_editor/dialogs/recipe_editor_scrape_dialog_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorScrapeDialog extends ConsumerStatefulWidget {
  const RecipeEditorScrapeDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecipeEditorScrapeDialogState();
}

class _RecipeEditorScrapeDialogState
    extends ConsumerState<RecipeEditorScrapeDialog> {
  final _urlKeys = <GlobalKey<FormState>>[];
  final _urlControllers = <TextEditingController>[];
  final _files = <XFile>[];

  IEMetadata? _selectedImporter;

  @override
  void dispose() {
    for (final controller in _urlControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(pIeImportersProvider);
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: FAppBar(
          title: context.l10n.recipe_editor_scrape_dialog__title,
          scrollController: null,
        ),
        body: SafeArea(
          child: FResponsive(
            child: Column(
              spacing: PADDING,
              children: [
                FPageIntroduction(
                  shape: .sunny,
                  icon: MdiIcons.cloudDownload,
                  description:
                      context.l10n.recipe_editor_scrape_dialog__description,
                ),

                if (provider.hasValue)
                  DropdownMenu(
                    initialSelection: _selectedImporter,
                    onSelected: setImporter,
                    selectOnly: true,
                    dropdownMenuEntries: [
                      for (final plugin in provider.value!)
                        DropdownMenuEntry(value: plugin, label: plugin.name),
                    ],
                  )
                else
                  const CircularProgressIndicator(),

                if (_selectedImporter != null) ...[
                  if (_selectedImporter!.import.contains(
                    IEImportType.UrlImport,
                  ))
                    _UrlCard(
                      controllers: _urlControllers,
                      keys: _urlKeys,
                      onAdd: addUrl,
                      onRemove: removeUrl,
                      onSubmit: submitUrls,
                    ),

                  if (_selectedImporter!.import.contains(
                    IEImportType.FileImport,
                  )) ...[
                    _FileCard(
                      files: _files,
                      onAdd: selectFiles,
                      onRemove: removeFile,
                      onSubmit: submitFiles,
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setImporter(IEMetadata? input) {
    setState(() {
      _selectedImporter = input;

      for (var it in _urlControllers) {
        it.dispose();
      }
      _urlControllers.clear();

      _urlKeys.clear();

      _files.clear();

      addUrl();
    });
  }

  void addUrl() {
    setState(() {
      _urlControllers.add(TextEditingController());
      _urlKeys.add(GlobalKey<FormState>());
    });
  }

  void removeUrl(int index) {
    setState(() {
      _urlControllers[index].dispose();
      _urlControllers.removeAt(index);

      _urlKeys.removeAt(index);
    });
  }

  void submitUrls() {
    if (!_urlKeys.every((it) => it.currentState!.validate())) return;

    final urls = _urlControllers.map((it) => it.text).toList();

    final returnValue = RecipeEditorScrapeDialogResult(
      pluginId: _selectedImporter!.id,
      type: .UrlImport,
      urls: urls,
    );

    context.pop(returnValue);
  }

  void selectFiles() async {
    final jsonTypeGroup = XTypeGroup(
      extensions: _selectedImporter!.supportedExtensions,
    );

    final files = await openFiles(
      acceptedTypeGroups: [jsonTypeGroup],
    );

    setState(() {
      _files.addAll(files);
    });
  }

  void removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void submitFiles() {
    if (_files.isEmpty) {
      context.showErrorSnackBar('Keine Daten ausgewählt');
      return;
    }

    final returnValue = RecipeEditorScrapeDialogResult(
      pluginId: _selectedImporter!.id,
      type: .FileImport,
      files: _files,
    );

    context.pop(returnValue);
  }

  // void submit() {
  //   if (!_urlKey.currentState!.validate()) return;
  //   final form = RecipeEditorScrapeDialogResult(
  //     type: .Url,
  //     urls: _urlController.text,
  //   );
  //   context.pop(form);
  // }
  //
  // void uploadJSON() async {
  //   const jsonTypeGroup = XTypeGroup(
  //     label: 'JSON',
  //     extensions: <String>['json'],
  //     uniformTypeIdentifiers: <String>['public.json'],
  //   );
  //
  //   final file = await openFile(
  //     acceptedTypeGroups: [jsonTypeGroup],
  //   );
  //
  //   if (file == null || !mounted) return;
  //
  //   final form = RecipeEditorScrapeDialogResult(
  //     type: .File,
  //     files: file,
  //     language: _language,
  //   );
  //
  //   context.pop(form);
  // }
}

class _UrlCard extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<GlobalKey<FormState>> keys;

  final void Function() onAdd;
  final void Function(int) onRemove;
  final void Function() onSubmit;

  const _UrlCard({
    required this.controllers,
    required this.keys,
    required this.onAdd,
    required this.onRemove,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        crossAxisAlignment: .start,
        spacing: PADDING,
        children: [
          FText(
            context.l10n.recipe_editor_scrape_dialog__download_title,
            style: .titleMedium,
          ),

          for (final (index, controller) in controllers.indexed)
            Row(
              children: [
                Expanded(
                  child: Form(
                    key: keys[index],
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(
                          context
                              .l10n
                              .recipe_editor_scrape_dialog__download_hint,
                        ),
                      ),
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return context.l10n.validator__is_empty;
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                if (controllers.length > 1)
                  IconButton(
                    onPressed: () => onRemove(index),
                    icon: const Icon(MdiIcons.minus),
                  ),
              ],
            ),

          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(MdiIcons.plus),
            label: Text(
              context.l10n.recipe_editor_scrape_dialog__add_url,
            ),
          ),

          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(MdiIcons.download),
            label: Text(
              context.l10n.recipe_editor_scrape_dialog__title,
            ),
          ),
        ],
      ),
    );
  }
}

class _FileCard extends StatelessWidget {
  final List<XFile> files;

  final void Function() onAdd;
  final void Function(int) onRemove;
  final void Function() onSubmit;

  const _FileCard({
    required this.files,
    required this.onAdd,
    required this.onRemove,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        crossAxisAlignment: .start,
        spacing: PADDING,
        children: [
          FText(
            context.l10n.recipe_editor_scrape_dialog__upload_title,
            style: .titleMedium,
          ),
          if (files.isNotEmpty)
            FWrap(
              children: [
                for (final (index, file) in files.indexed)
                  Chip(
                    label: Text(file.name),
                    onDeleted: () => onRemove(index),
                  ),
              ],
            ),
          FilledButton.icon(
            onPressed: onAdd,
            label: Text(
              context.l10n.recipe_editor_scrape_dialog__select_file,
            ),
            icon: const Icon(MdiIcons.file),
          ),

          FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(MdiIcons.download),
            label: Text(
              context.l10n.recipe_editor_scrape_dialog__title,
            ),
          ),
        ],
      ),
    );
  }
}
