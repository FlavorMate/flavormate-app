import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_dio.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/presentation/common/layouts/auth_page_template.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class AuthRegisterPage extends ConsumerStatefulWidget {
  const AuthRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthRegisterPageState();
}

class _AuthRegisterPageState extends ConsumerState<AuthRegisterPage> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageTemplate(
      title: context.l10n.auth_register_page__title,
      subtitle: context.l10n.auth_register_page__hint_1,
      bottomChild: M3EButton.text(
        onPressed: context.pop,
        child: Text(context.l10n.btn_back),
      ),
      children: [
        Form(
          key: _form,
          child: Column(
            spacing: PADDING / 2,
            children: [
              FTextFormField(
                controller: _displayNameController,
                label: context.l10n.auth_register_page__display_name,
                autocorrect: false,
                validators: (input) {
                  if (UValidator.isEmpty(input)) {
                    return context.l10n.validator__is_empty;
                  }
                  return null;
                },
              ),
              FTextFormField(
                controller: _usernameController,
                label: context.l10n.auth_register_page__username,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                validators: (input) {
                  if (UValidator.isEmpty(input)) {
                    return context.l10n.validator__is_empty;
                  }

                  return null;
                },
              ),
              FTextFormField(
                controller: _mailController,
                label: context.l10n.auth_register_page__email,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                validators: (input) {
                  if (UValidator.isEmpty(input)) {
                    return context.l10n.validator__is_empty;
                  }

                  if (!UValidator.isMail(input!)) {
                    return context.l10n.validator__is_email;
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  label: Text(
                    context.l10n.auth_register_page__password,
                  ),
                  border: const OutlineInputBorder(),
                ),
                autocorrect: false,
                obscureText: true,
                validator: (input) {
                  if (UValidator.isEmpty(input)) {
                    return context.l10n.validator__is_empty;
                  }

                  if (!UValidator.isSecure(input!)) {
                    return context.l10n.validator__is_secure;
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: .centerRight,
          child: M3EButton(
            onPressed: createUser,
            child: Text(context.l10n.btn_register),
          ),
        ),
      ],
    );
  }

  void createUser() async {
    if (!_form.currentState!.validate()) return;

    context.showLoadingDialog();

    bool isOK = false;
    try {
      final response = await ref
          .read(pDioPublicProvider)
          .post(
            ApiConstants.Registration,
            data: {
              'displayName': _displayNameController.text,
              'username': _usernameController.text,
              'email': _mailController.text,
              'password': _passwordController.text,
            },
          );

      isOK = response.isOK;
    } catch (_) {
      isOK = false;
    }

    if (!mounted) return;
    context.pop();

    if (isOK) {
      context.pop();
      context.showTextSnackBar(context.l10n.auth_register_page__success);
    } else {
      context.showTextSnackBar(context.l10n.auth_register_page__failure);
    }
  }
}
