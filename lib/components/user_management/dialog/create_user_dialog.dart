import 'package:flavormate/components/dialogs/t_alert_dialog.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mailController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TAlertDialog(
      title: L10n.of(context).d_admin_user_management_create_title,
      scrollable: true,
      submit: apply,
      child: Form(
        key: _formKey,
        child: TColumn(
          children: [
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(L10n.of(context)
                    .d_admin_user_management_create_displayName),
              ),
              autocorrect: false,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                    L10n.of(context).d_admin_user_management_create_username),
              ),
              autocorrect: false,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                    L10n.of(context).d_admin_user_management_create_password),
              ),
              obscureText: true,
              validator: (value) {
                if (UValidator.isEmpty(value)) {
                  return L10n.of(context).v_isEmpty;
                }

                return null;
              },
            ),
            TextFormField(
              controller: _mailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label:
                    Text(L10n.of(context).d_admin_user_management_create_mail),
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
          ],
        ),
      ),
    );
  }

  apply() {
    if (_formKey.currentState!.validate()) {
      context.pop({
        'displayName': _displayNameController.text,
        'username': _userNameController.text,
        'password': _passwordController.text,
        'mail': _mailController.text,
      });
    }
  }
}
