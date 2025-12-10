import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/shared/models/account_create_form.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdministrationAccountManagementNewAccountDialog extends StatefulWidget {
  const AdministrationAccountManagementNewAccountDialog({super.key});

  @override
  State<StatefulWidget> createState() =>
      _AdministrationAccountManagementNewAccountDialogState();
}

class _AdministrationAccountManagementNewAccountDialogState
    extends State<AdministrationAccountManagementNewAccountDialog> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context
          .l10n
          .administration_account_management_new_account_dialog__title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          children: [
            FTextFormField(
              controller: _displayNameController,
              label: context
                  .l10n
                  .administration_account_management_new_account_dialog__display_name,
              validators: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }
                return null;
              },
            ),
            FTextFormField(
              controller: _usernameController,
              label: context
                  .l10n
                  .administration_account_management_new_account_dialog__username,
              validators: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }
                return null;
              },
            ),
            FTextFormField(
              controller: _passwordController,
              label: context
                  .l10n
                  .administration_account_management_new_account_dialog__password,
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
            FTextFormField(
              controller: _emailController,
              label: context
                  .l10n
                  .administration_account_management_new_account_dialog__email,
              validators: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isMail(value!)) {
                  return context.l10n.validator__is_email;
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

    context.pop(
      AccountCreateForm(
        displayName: _displayNameController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        email: _emailController.text,
      ),
    );
  }
}
