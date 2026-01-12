import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/presentation/common/layouts/f_bottom_navigation_back_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_button.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive_card.dart';
import 'package:flavormate/presentation/features/auth/providers/p_login_page.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_password_text_field.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_username_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      bottomNavigationBarBuilder: (_, _) => const FBottomNavigationBackBar(),
      builder: (_, data) => Center(
        child: FResponsiveCard(
          child: Column(
            crossAxisAlignment: .start,
            spacing: PADDING * 1.5,
            mainAxisSize: .min,
            children: [
              const FLogo(size: 76),
              Column(
                spacing: PADDING / 2,
                crossAxisAlignment: .start,
                children: [
                  FText(
                    context.l10n.auth_login_page__title,
                    style: .headlineMedium,
                  ),
                  FText(
                    context.l10n.auth_login_page__hint_1,
                    style: .titleMedium,
                  ),
                ],
              ),
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
                      if (data.enableRecovery)
                        Align(
                          alignment: Alignment.topLeft,
                          child: FTextButton(
                            onPressed: startRecovery,
                            value:
                                context.l10n.auth_login_page__forgot_password,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: .end,
                children: [
                  FButton(
                    width: 125,
                    onPressed: login,
                    label: context.l10n.btn_login,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      onError: FEmptyMessage(
        title: context.l10n.auth_login_page__on_error,
        icon: StateIconConstants.login.errorIcon,
      ),
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
