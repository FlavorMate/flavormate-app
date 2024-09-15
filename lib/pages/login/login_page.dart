import 'package:flavormate/clients/api_client.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/extensions/e_build_context.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/api/login.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/root_bundle/p_backend_url.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _serverController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _staticServer = false;

  @override
  void initState() {
    ref.listenManual(pServerProvider, fireImmediately: true, (_, value) {
      if (_serverController.text.isNotEmpty) return;
      _serverController.text = value;
    });

    _staticServer = ref.read(pBackendUrlProvider).requireValue != null;
    super.initState();
  }

  @override
  void dispose() {
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING),
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/Transparent.png',
                      width: 128,
                      height: 128,
                    ),
                    const SizedBox(height: PADDING),
                    TText(L10n.of(context).app_title, TextStyles.headlineLarge),
                    const SizedBox(height: PADDING * 2),
                    TextField(
                      enabled: !_staticServer,
                      readOnly: _staticServer,
                      controller: _serverController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_login_server),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      onChanged: (value) =>
                          ref.read(pServerProvider.notifier).set(value),
                    ),
                    const SizedBox(height: PADDING),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_login_username),
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      autofillHints: const [AutofillHints.username],
                    ),
                    const SizedBox(height: PADDING),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        label: Text(L10n.of(context).p_login_password),
                        border: const OutlineInputBorder(),
                      ),
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
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
    );
  }

  Future<void> login() async {
    try {
      await ref.read(pAuthStateProvider.notifier).login(Login(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    } on ApiClientException catch (_) {
      if (!context.mounted) return;
      context.showTextSnackBar(
        L10n.of(context).p_login_error,
      );
    }
  }
}
