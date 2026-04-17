import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecipeImportItemUrlDialog extends StatefulWidget {
  const RecipeImportItemUrlDialog({super.key});

  @override
  State<StatefulWidget> createState() => _RecipeImportItemUrlDialogState();
}

class _RecipeImportItemUrlDialogState extends State<RecipeImportItemUrlDialog> {
  final controller = TextEditingController();
  final formState = GlobalKey<FormState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.recipe_import_item_url_dialog__title,
      negativeLabel: context.l10n.btn_close,
      positiveLabel: context.l10n.btn_add,
      submit: submit,
      child: Form(
        key: formState,
        child: FTextFormField(
          label: context.l10n.recipe_import_item_url_dialog__label,
          controller: controller,
          onFieldSubmitted: (_) => submit(),
          validators: (input) {
            if (UValidator.isEmpty(input)) {
              return context.l10n.validator__is_empty;
            }

            if (!UValidator.isHttpUrl(input!)) {
              return context.l10n.validator__is_http_url;
            }

            return null;
          },
        ),
      ),
    );
  }

  void submit() {
    if (!formState.currentState!.validate()) return;

    context.pop(controller.text);
  }
}
