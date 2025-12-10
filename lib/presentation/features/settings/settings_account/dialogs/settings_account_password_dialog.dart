import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountPasswordDialog extends StatefulWidget {
  const SettingsAccountPasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsAccountPasswordDialogState();
}

class _SettingsAccountPasswordDialogState
    extends State<SettingsAccountPasswordDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPassword1Controller = TextEditingController();
  final _newPassword2Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPassword1Controller.dispose();
    _newPassword2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.settings_account_password_dialog__title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          children: [
            TextFormField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                  context.l10n.settings_account_password_dialog__old_pwd,
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                return null;
              },
            ),
            const Divider(),
            TextFormField(
              controller: _newPassword1Controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                  context.l10n.settings_account_password_dialog__new_pwd_1,
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isSecure(value!)) {
                  return context.l10n.validator__is_secure;
                }

                return null;
              },
            ),
            TextFormField(
              controller: _newPassword2Controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                  context.l10n.settings_account_password_dialog__new_pwd_2,
                ),
              ),
              obscureText: true,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isEqual(value!, _newPassword1Controller.text)) {
                  return context.l10n.validator__is_equal;
                }

                if (!UValidator.isSecure(value)) {
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

    final form = AccountUpdateDto(
      oldPassword: _oldPasswordController.text,
      newPassword: _newPassword2Controller.text,
    );

    context.pop(form);
  }
}
