import 'package:flavormate/clients/api_client.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/api/login.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  final bool isStatic;
  final String server;

  const LoginForm({
    super.key,
    required this.server,
    required this.isStatic,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('☁️ ${widget.server}'),
            if (!widget.isStatic)
              GestureDetector(
                onTap: changeServer,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    L10n.of(context).p_login_change_server,
                    style: TextStyle(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING),
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/Transparent.png',
                        width: 128,
                        height: 128,
                      ),
                      TText(
                          L10n.of(context).app_title, TextStyles.headlineLarge),
                      const SizedBox(height: PADDING * 2),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          label: Text(L10n.of(context).p_login_username),
                          border: const OutlineInputBorder(),
                        ),
                        autocorrect: false,
                        autofillHints: const [AutofillHints.username],
                        validator: (input) {
                          if (UValidator.isEmpty(input)) {
                            return L10n.of(context).v_isEmpty;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: PADDING),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          label: Text(L10n.of(context).p_login_password),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                        autofillHints: const [AutofillHints.password],
                        validator: (input) {
                          if (UValidator.isEmpty(input)) {
                            return L10n.of(context).v_isEmpty;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: PADDING),
                      SizedBox(
                        width: 128,
                        child: FilledButton(
                          onPressed: () => login(),
                          child: Text(L10n.of(context).btn_login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeServer() {
    ref.read(pServerProvider.notifier).set('');
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final loginForm = Login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
      await ref.read(pAuthStateProvider.notifier).login(loginForm);
    } on ApiClientException catch (_) {
      if (!context.mounted) return;
      context.showTextSnackBar(L10n.of(context).p_login_error);
    }
  }
}