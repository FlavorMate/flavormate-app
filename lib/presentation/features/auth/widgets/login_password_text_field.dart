import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:material_ui/material_ui.dart';

class LoginPasswordTextField extends StatelessWidget {
  const LoginPasswordTextField({
    super.key,
    required this._passwordController,
    required this.onFieldSubmitted,
  });

  final TextEditingController _passwordController;
  final void Function() onFieldSubmitted;

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
      onFieldSubmitted: (_) => onFieldSubmitted(),
    );
  }
}
