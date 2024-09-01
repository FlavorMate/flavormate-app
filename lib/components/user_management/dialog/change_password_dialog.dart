import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(L10n.of(context).d_admin_user_management_change_password_title),
      content: SizedBox(
        // height: 300,
        width: 250,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: TColumn(
              children: [
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(L10n.of(context)
                        .d_admin_user_management_change_password_new_password),
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
                  controller: _passwordController2,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(L10n.of(context)
                        .d_admin_user_management_change_password_new_password_2),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (UValidator.isEmpty(value)) {
                      return L10n.of(context).v_isEmpty;
                    }

                    if (!UValidator.isSecure(value!)) {
                      return L10n.of(context).v_isSecure;
                    }

                    if (!UValidator.isEqual(value, _passwordController.text)) {
                      return L10n.of(context).v_isEqual;
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
        'password': _passwordController2.text,
      });
    }
  }
}
