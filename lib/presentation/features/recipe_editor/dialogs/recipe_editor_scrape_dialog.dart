import 'package:file_selector/file_selector.dart';
import 'package:flavormate/core/config/features/p_feature_scraper_import.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_localizations.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/shared/enums/language.dart';
import 'package:flavormate/presentation/common/widgets/f_app_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_card.dart';
import 'package:flavormate/presentation/common/widgets/f_page_introduction.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  late Language _language;

  @override
  void initState() {
    _language = currentLanguage();

    super.initState();
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enableImport = ref.read(pFeatureScraperImportProvider);

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

                const SizedBox(height: PADDING * 2),

                Column(
                  crossAxisAlignment: .start,
                  spacing: PADDING / 2,
                  children: [
                    FText(
                      context.l10n.recipe_editor_scrape_dialog__download_title,
                      style: .titleMedium,
                    ),
                    Row(
                      spacing: PADDING,
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _urlController,
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
                        Padding(
                          padding: const .only(top: 4),
                          child: IconButton.filled(
                            onPressed: submit,
                            icon: const Icon(MdiIcons.download),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (enableImport) ...[
                  const Divider(),
                  Column(
                    crossAxisAlignment: .start,
                    spacing: PADDING,
                    children: [
                      FText(
                        context.l10n.recipe_editor_scrape_dialog__upload_title,
                        style: .titleMedium,
                      ),
                      Row(
                        spacing: PADDING,
                        children: [
                          FText(
                            context
                                .l10n
                                .recipe_editor_scrape_dialog__upload_language,
                            style: .bodyLarge,
                          ),
                          SegmentedButton(
                            segments: [
                              for (final language in Language.sorted(context))
                                ButtonSegment<Language>(
                                  value: language,
                                  label: Text(language.getL10n(context)),
                                ),
                            ],
                            selected: {_language},
                            onSelectionChanged: setLanguage,
                          ),
                        ],
                      ),
                      FCard(
                        color: context.colorScheme.primaryContainer,
                        onTap: uploadJSON,
                        child: Column(
                          spacing: PADDING / 2,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(MdiIcons.fileUpload, size: 64),
                            FText(
                              context
                                  .l10n
                                  .recipe_editor_scrape_dialog__upload_hint,
                              style: FTextStyle.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    final form = RecipeEditorScrapeDialogResult(
      type: .Url,
      url: _urlController.text,
    );
    context.pop(form);
  }

  void setLanguage(Set<Language> lang) {
    setState(() {
      _language = lang.first;
    });
  }

  void uploadJSON() async {
    const jsonTypeGroup = XTypeGroup(
      label: 'JSON',
      extensions: <String>['json'],
      uniformTypeIdentifiers: <String>['public.json'],
    );

    final file = await openFile(
      acceptedTypeGroups: [jsonTypeGroup],
    );

    if (file == null || !mounted) return;

    final form = RecipeEditorScrapeDialogResult(
      type: .File,
      file: file,
      language: _language,
    );

    context.pop(form);
  }
}
