import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginPasswordTextField extends StatelessWidget {
  const LoginPasswordTextField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return FTextFormField(
      controller: _passwordController,
      label: L10n.of(context).login_password_text_field__label,
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      validators: (input) {
        if (UValidator.isEmpty(input)) {
          return L10n.of(context).validator__is_empty;
        }

        return null;
      },
    );
  }
}
