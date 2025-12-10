import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
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
      label: context.l10n.login_password_text_field__label,
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      validators: (input) {
        if (UValidator.isEmpty(input)) {
          return context.l10n.validator__is_empty;
        }

        return null;
      },
    );
  }
}
