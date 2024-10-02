import 'package:flavormate/components/t_app_bar.dart';
import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
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
    return Scaffold(
      appBar: TAppBar(title: L10n.of(context).p_registration_title),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING),
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: Form(
                key: _form,
                child: TColumn(
                  children: [
                    Icon(
                      MdiIcons.accountBoxPlusOutline,
                      size: 128,
                    ),
                    TText(
                      L10n.of(context).p_registration_title,
                      TextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        label:
                            Text(L10n.of(context).p_registration_display_name),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return L10n.of(context).v_isEmpty;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_registration_username),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return L10n.of(context).v_isEmpty;
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _mailController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_registration_mail),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return L10n.of(context).v_isEmpty;
                        }

                        if (!UValidator.isMail(input!)) {
                          return L10n.of(context).v_isMail;
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_registration_password),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (input) {
                        if (UValidator.isEmpty(input)) {
                          return L10n.of(context).v_isEmpty;
                        }

                        if (!UValidator.isSecure(input!)) {
                          return L10n.of(context).v_isSecure;
                        }

                        return null;
                      },
                    ),
                    FilledButton(
                      onPressed: createUser,
                      child: Text(L10n.of(context).btn_registration),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createUser() async {
    if (!_form.currentState!.validate()) return;

    context.showLoadingDialog();

    final response =
        await ref.read(pApiProvider).selfServiceClient.registration(
              displayName: _displayNameController.text,
              username: _usernameController.text,
              mail: _mailController.text,
              password: _passwordController.text,
            );

    if (!mounted) return;
    context.pop();

    if (response) {
      context.showTextSnackBar(L10n.of(context).p_registration_confirm);
      context.pop();
    } else {
      context.showTextSnackBar(L10n.of(context).p_registration_error);
    }
  }
}
