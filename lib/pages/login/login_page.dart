import 'package:flavormate/components/login/login_form.dart';
import 'package:flavormate/components/login/server_form.dart';
import 'package:flavormate/riverpod/root_bundle/p_backend_url.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStatic = ref.watch(pBackendUrlProvider).requireValue;
    final serverURL = ref.watch(pServerProvider);

    if (serverURL.isEmpty) {
      return ServerForm(readOnly: isStatic != null);
    } else {
      return LoginForm(
        server: serverURL,
        isStatic: isStatic != null,
      );
    }
  }
}
