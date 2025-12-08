import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdministrationAccountManagementPasswordDialog extends StatefulWidget {
  const AdministrationAccountManagementPasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() =>
      _AdministrationAccountManagementPasswordDialogState();
}

class _AdministrationAccountManagementPasswordDialogState
    extends State<AdministrationAccountManagementPasswordDialog> {
  final _newPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title:
          context.l10n.administration_account_management_password_dialog__title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          children: [
            FTextFormField(
              controller: _newPasswordController,
              label: context
                  .l10n
                  .administration_account_management_password_dialog__new_password,
              obscureText: true,
              validators: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isSecure(value!)) {
                  return context.l10n.validator__is_secure;
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void apply() {
    if (!_formKey.currentState!.validate()) return;

    context.pop(_newPasswordController.text);
  }
}
