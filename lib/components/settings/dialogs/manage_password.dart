import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagePassword extends StatefulWidget {
  const ManagePassword({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
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
    return AlertDialog(
      title: Text(L10n.of(context).d_settings_manage_password_title),
      content: SizedBox(
        // height: 300,
        width: 250,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: TColumn(
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label:
                        Text(L10n.of(context).d_settings_manage_password_old),
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
                  controller: _newPassword1Controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label:
                        Text(L10n.of(context).d_settings_manage_password_new),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (UValidator.isEmpty(value)) {
                      return L10n.of(context).v_isEmpty;
                    }

                    if (!UValidator.isSecure(value!)) {
                      return L10n.of(context).v_isSecure;
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPassword2Controller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label:
                        Text(L10n.of(context).d_settings_manage_password_new_2),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (UValidator.isEmpty(value)) {
                      return L10n.of(context).v_isEmpty;
                    }

                    if (!UValidator.isEqual(
                      value!,
                      _newPassword1Controller.text,
                    )) {
                      return L10n.of(context).v_isEqual;
                    }

                    if (!UValidator.isSecure(value)) {
                      return L10n.of(context).v_isSecure;
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(L10n.of(context).btn_cancel),
        ),
        FilledButton(
          onPressed: () => apply(),
          child: Text(L10n.of(context).btn_save),
        ),
      ],
    );
  }

  apply() {
    if (_formKey.currentState!.validate()) {
      context.pop({
        'oldPassword': _oldPasswordController.text,
        'newPassword': _newPassword2Controller.text,
      });
    }
  }
}
