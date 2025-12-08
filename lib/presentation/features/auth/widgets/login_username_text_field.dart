import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginUsernameTextField extends StatelessWidget {
  const LoginUsernameTextField({
    super.key,
    required TextEditingController usernameController,
  }) : _usernameController = usernameController;

  final TextEditingController _usernameController;

  @override
  Widget build(BuildContext context) {
    return FTextFormField(
      controller: _usernameController,
      label: context.l10n.login_username_text_field__label,
      autocorrect: false,
      autofillHints: const [AutofillHints.username],
      keyboardType: TextInputType.visiblePassword,
      validators: (input) {
        if (UValidator.isEmpty(input)) {
          return context.l10n.validator__is_empty;
        }

        return null;
      },
    );
  }
}
