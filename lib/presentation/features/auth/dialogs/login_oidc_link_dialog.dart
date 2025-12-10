import 'dart:async';

import 'package:flavormate/core/auth/oidc/p_oidc.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_duration.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/presentation/common/layouts/f_bottom_navigation_back_bar.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_icon.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_password_text_field.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_username_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginOIDCLinkDialog extends ConsumerStatefulWidget {
  final OIDCProvider provider;
  final String accessToken;

  const LoginOIDCLinkDialog({
    super.key,
    required this.accessToken,
    required this.provider,
  });

  Map get jwt => JwtDecoder.decode(accessToken);

  String? get displayName => jwt['name'];

  DateTime get expiresAt => JwtDecoder.getExpirationDate(accessToken);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginOIDCLinkDialogState();
}

class _LoginOIDCLinkDialogState extends ConsumerState<LoginOIDCLinkDialog> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late DateTime _expiresAt;
  late Duration _expiresIn;

  late Timer? _expiresAtTimer;
  late Timer? _tokenExpiredTimer;

  Duration get _calculateDuration => _expiresAt.difference(DateTime.now());

  @override
  void initState() {
    _expiresAt = widget.expiresAt;
    _expiresIn = _calculateDuration;

    _expiresAtTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _expiresIn = _calculateDuration),
    );

    _tokenExpiredTimer = Timer(
      _calculateDuration - const Duration(seconds: 2),
      () {
        _expiresAtTimer?.cancel();
        context.pop();
        context.showTextSnackBar(
          context.l10n.login_oidc_link_dialog__token_expired,
        );
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _expiresAtTimer?.cancel();
    _tokenExpiredTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        bottomNavigationBar: const FBottomNavigationBackBar(),
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                right: PADDING / 2,
                top: PADDING / 2,
                child: Chip(label: Text(_expiresIn.beautify(context))),
              ),
              Center(
                child: FResponsive(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FOidcIcon(
                        provider: widget.provider,
                        width: 128,
                        height: 128,
                      ),
                      SizedBox(
                        width: BUTTON_WIDTH,
                        child: FText(
                          context.l10n.login_oidc_link_dialog__hint_1(
                            widget.displayName ?? '',
                          ),
                          style: FTextStyle.headlineMedium,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: PADDING / 2),
                      SizedBox(
                        width: BUTTON_WIDTH,
                        child: FText(
                          context.l10n.login_oidc_link_dialog__hint_2(
                            widget.provider.name,
                          ),
                          style: FTextStyle.bodyMedium,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: PADDING),
                      AutofillGroup(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              LoginUsernameTextField(
                                usernameController: _usernameController,
                              ),
                              const SizedBox(height: PADDING),
                              LoginPasswordTextField(
                                passwordController: _passwordController,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: PADDING * 2),
                      FButton(
                        width: BUTTON_WIDTH,
                        onPressed: linkAccount,
                        label: context.l10n.btn_link_account,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> linkAccount() async {
    if (!_formKey.currentState!.validate()) return;

    context.showLoadingDialog();

    final response = await ref
        .read(pOIDCProvider.notifier)
        .linkAccount(
          widget.accessToken,
          _usernameController.text,
          _passwordController.text,
        );

    if (!mounted) return;
    context.pop();

    if (response) {
      context.showTextSnackBar(
        context.l10n.login_oidc_link_dialog__on_success,
      );
    } else {
      context.showTextSnackBar(
        context.l10n.login_oidc_link_dialog__on_error,
      );
    }
  }
}
