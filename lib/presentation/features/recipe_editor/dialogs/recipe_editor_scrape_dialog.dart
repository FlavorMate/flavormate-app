import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
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
      title: L10n.of(context).recipe_editor_scrape_dialog__title,
      submit: submit,
      positiveLabel: L10n.of(context).btn_import,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(L10n.of(context).recipe_editor_scrape_dialog__hint),
          ),
          validator: (input) {
            if (UValidator.isEmpty(input)) {
              return L10n.of(context).validator__is_empty;
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
