import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/features/accounts/account_update_dto.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsAccountEmailDialog extends StatefulWidget {
  const SettingsAccountEmailDialog({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsAccountEmailDialogState();
}

class _SettingsAccountEmailDialogState
    extends State<SettingsAccountEmailDialog> {
  final _newMail1Controller = TextEditingController();
  final _newMail2Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newMail1Controller.dispose();
    _newMail2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FAlertDialog(
      title: context.l10n.settings_account_email_dialog__title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: PADDING,
          children: [
            FTextFormField(
              label: context.l10n.settings_account_email_dialog__new_e_mail_1,
              controller: _newMail1Controller,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
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
            FTextFormField(
              controller: _newMail2Controller,
              label: context.l10n.settings_account_email_dialog__new_e_mail_2,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              validators: (value) {
                if (UValidator.isEmpty(value)) {
                  return context.l10n.validator__is_empty;
                }

                if (!UValidator.isEqual(value!, _newMail1Controller.text)) {
                  return context.l10n.validator__is_equal;
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
    if (_formKey.currentState!.validate()) {
      context.pop(AccountUpdateDto(email: _newMail1Controller.text));
    }
  }
}
