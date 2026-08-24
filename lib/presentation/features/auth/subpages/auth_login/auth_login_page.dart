import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_ref.dart';
import 'package:flavormate/presentation/common/layouts/auth_page_template.dart';
import 'package:flavormate/presentation/common/widgets/f_text_button.dart';
import 'package:flavormate/presentation/features/auth/providers/p_auth_username.dart';
import 'package:flavormate/presentation/features/auth/providers/p_login_page.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_password_text_field.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_username_text_field.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

class AuthLoginPage extends ConsumerStatefulWidget {
  const AuthLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthLoginPageState();

  PLoginPageProvider get provider => pLoginPageProvider;
}

class _AuthLoginPageState extends ConsumerState<AuthLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    ref.listenOnce(
      pAuthUsernameProvider,
      (data) => _usernameController.text = data,
    );

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(widget.provider).requireValue;

    return AuthPageTemplate(
      title: context.l10n.auth_login_page__title,
      subtitle: context.l10n.auth_login_page__hint_1,
      bottomChild: M3EButton.text(
        onPressed: context.pop,
        child: Text(context.l10n.btn_back),
      ),
      children: [
        AutofillGroup(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: PADDING / 2,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoginUsernameTextField(
                  usernameController: _usernameController,
                ),
                LoginPasswordTextField(
                  passwordController: _passwordController,
                  onFieldSubmitted: login,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            if (data.enableRecovery)
              FTextButton(
                onPressed: startRecovery,
                value: context.l10n.auth_login_page__forgot_password,
              ),
            const SizedBox.shrink(),
            M3EButton(
              onPressed: login,
              child: Text(context.l10n.btn_login),
            ),
          ],
        ),
      ],
    );
  }

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    context.showLoadingDialog();

    final response = await ref
        .read(widget.provider.notifier)
        .login(
          _usernameController.text,
          _passwordController.text,
        );

    if (!mounted) return;
    context.pop();

    if (response.hasError) {
      context.showTextSnackBar(
        context.l10n.auth_login_page__login_on_error,
      );
    }
  }

  void startRecovery() {
    context.routes.recovery();
  }
}
