import 'package:flavormate/core/auth/oidc/p_oidc.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/constants/route_constants.dart';
import 'package:flavormate/core/constants/state_icon_constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_card.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_provider_page.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/auth/dialogs/login_oidc_link_dialog.dart';
import 'package:flavormate/presentation/features/auth/providers/p_login_page.dart';
import 'package:flavormate/presentation/features/auth/widgets/login_compatibility_admonition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();

  PLoginPageProvider get provider => pLoginPageProvider;
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    ref.listenManual(widget.provider, (_, data) async {
      if (data.isLoading) return;
      if (data.hasError) {
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        ref.read(widget.provider.notifier).invalidate();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FProviderPage(
      provider: widget.provider,
      builder: (_, data) => Center(
        child: FResponsive(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FLogo(size: 128),
              FText(
                context.l10n.flavormate,
                style: FTextStyle.headlineLarge,
              ),
              const SizedBox(height: PADDING * 2),
              FButton(
                width: BUTTON_WIDTH,
                label: context.l10n.auth_page__login,
                onPressed: () =>
                    context.pushNamed(RouteConstants.AuthLogin.name),
              ),

              if (data.enableRegistration) ...[
                const SizedBox(height: PADDING),
                FButton(
                  width: BUTTON_WIDTH,
                  label: context.l10n.auth_page__register,
                  onPressed: () =>
                      context.pushNamed(RouteConstants.AuthRegister.name),
                ),
              ],
              if (data.compatibility ==
                  VersionComparison.majorIncompatible) ...[
                const SizedBox(height: PADDING),
                LoginCompatibilityAdmonition(compatibility: data.compatibility),
              ],
              if (data.oidcProviders.isNotEmpty) ...[
                const SizedBox(height: PADDING),
                Row(
                  spacing: PADDING / 4,
                  children: [
                    const Expanded(child: Divider()),
                    Text(context.l10n.auth_page__or),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: PADDING),
                FText(
                  context.l10n.auth_page__login_with,
                  style: FTextStyle.bodyMedium,
                ),
                const SizedBox(height: PADDING),
                FWrap(
                  children: [
                    for (final provider in data.oidcProviders)
                      FOidcCard(
                        provider: provider,
                        onTap: () => openOIDC(provider),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      loadingShowAppBar: false,
      bottomNavigationBarBuilder: (_, data) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: PADDING / 4,
        children: [
          Text('☁️ ${data.server}'),
          if (!data.isStatic)
            TextButton(
              onPressed: changeServer,
              child: Text(context.l10n.login_page__change_server),
            ),
        ],
      ),

      onError: FEmptyMessage(
        title: context.l10n.login_page__on_error,
        icon: StateIconConstants.login.errorIcon,
        showLogoutButton: true,
      ),
    );
  }

  void changeServer() async {
    await ref.read(widget.provider.notifier).resetServer();

    if (!mounted) return;
    await context.routes.server(replace: true);
  }

  void openOIDC(OIDCProvider provider) async {
    context.showLoadingDialog();

    final accessToken = await ref
        .read(pOIDCProvider.notifier)
        .requestTokens(provider);

    if (accessToken == null) {
      if (!mounted) return;
      context.pop();
      context.showTextSnackBar(
        context.l10n.auth_page__oidc_error(provider.name),
      );
      return;
    }

    final loginSuccessful = await ref
        .read(pOIDCProvider.notifier)
        .login(accessToken);

    if (!mounted) return;
    context.pop();

    if (!loginSuccessful) {
      await showDialog(
        context: context,
        builder: (_) => LoginOIDCLinkDialog(
          accessToken: accessToken,
          provider: provider,
        ),
      );
    }
  }
}
