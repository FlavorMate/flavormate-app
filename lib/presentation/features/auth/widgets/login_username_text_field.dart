import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
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
      label: L10n.of(context).login_username_text_field__label,
      autocorrect: false,
      autofillHints: const [AutofillHints.username],
      validators: (input) {
        if (UValidator.isEmpty(input)) {
          return L10n.of(context).validator__is_empty;
        }

        return null;
      },
    );
  }
}
