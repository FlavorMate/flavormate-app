import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeEditorScrapeDialog extends StatefulWidget {
  const RecipeEditorScrapeDialog({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeEditorScrapeDialogState();
}

class _RecipeEditorScrapeDialogState extends State<RecipeEditorScrapeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.recipe_editor_scrape_dialog__title,
      submit: submit,
      positiveLabel: context.l10n.btn_import,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(context.l10n.recipe_editor_scrape_dialog__hint),
          ),
          validator: (input) {
            if (UValidator.isEmpty(input)) {
              return context.l10n.validator__is_empty;
            }

            return null;
          },
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;
    context.pop(_urlController.text);
  }
}
