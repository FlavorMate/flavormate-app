import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageMail extends StatefulWidget {
  final String? mail;

  const ManageMail({super.key, this.mail});

  @override
  State<StatefulWidget> createState() => _ManageMailState();
}

class _ManageMailState extends State<ManageMail> {
  final _oldMailController = TextEditingController();
  final _newMail1Controller = TextEditingController();
  final _newMail2Controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldMailController.dispose();
    _newMail1Controller.dispose();
    _newMail2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_settings_manage_mail_title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: TColumn(
          children: [
            if (widget.mail != null)
              TextFormField(
                controller: _oldMailController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(L10n.of(context).d_settings_manage_mail_old),
                ),
                autocorrect: false,
                validator: (value) {
                  if (UValidator.isEmpty(value)) {
                    return L10n.of(context).v_isEmpty;
                  }

                  if (!UValidator.isMail(value!)) {
                    return L10n.of(context).v_isMail;
                  }

                  if (!UValidator.isEqual(value, widget.mail!)) {
                    return L10n.of(context).v_isEqual;
                  }
                  return null;
                },
              ),
            TextFormField(
              controller: _newMail1Controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_settings_manage_mail_new),
              ),
              autocorrect: false,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return L10n.of(context).v_isEmpty;
                }

                if (!UValidator.isMail(value!)) {
                  return L10n.of(context).v_isMail;
                }

                return null;
              },
            ),
            TextFormField(
              controller: _newMail2Controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context).d_settings_manage_mail_new_2),
              ),
              autocorrect: false,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return L10n.of(context).v_isEmpty;
                }

                if (!UValidator.isMail(value!)) {
                  return L10n.of(context).v_isMail;
                }

                if (!UValidator.isEqual(value, _newMail1Controller.text)) {
                  return L10n.of(context).v_isEqual;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  apply() {
    if (_formKey.currentState!.validate()) {
      context.pop(_newMail1Controller.text);
    }
  }
}
