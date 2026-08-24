import 'package:flavormate/core/auth/oidc/p_oidc.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/extensions/e_ref.dart';
import 'package:flavormate/core/utils/u_validator.dart';
import 'package:flavormate/data/models/core/auth/oidc/oidc_provider.dart';
import 'package:flavormate/presentation/common/layouts/auth_page_template.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_oidc/f_oidc_icon.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_text_button.dart';
import 'package:flavormate/presentation/common/widgets/f_text_form_field.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/features/auth/dialogs/login_oidc_link_dialog.dart';
import 'package:flavormate/presentation/features/auth/providers/p_auth_username.dart';
import 'package:flavormate/presentation/features/auth/providers/p_login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();

  PLoginPageProvider get provider => pLoginPageProvider;
}

class _LoginPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ref.listenOnce(pAuthUsernameProvider, (data) {
      _usernameController.text = data;
    });

    ref.listenManual(widget.provider, (_, data) async {
      if (data.isLoading) {
        return;
      } else if (data.hasError) {
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        ref.read(widget.provider.notifier).invalidate();
      } else if (data.hasValue) {
        final value = data.value!;

        if (value.compatibility == .majorIncompatible) {
          context.routes.serverOutdated();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(widget.provider);

    if (provider.hasError) {
      return Material(child: _buildErrorWidget(context));
    }

    if (!provider.hasValue) {
      return const Material(child: Center(child: M3ELoadingIndicator()));
    }

    final data = provider.requireValue;

    return AuthPageTemplate(
      title: context.l10n.auth_login_page__title,
      subtitle: context.l10n.auth_page__hint,
      bottomChild: Column(
        spacing: PADDING / 4,
        mainAxisSize: .min,
        children: [
          Row(
            spacing: PADDING / 2,
            mainAxisAlignment: .center,
            children: [
              Icon(
                Symbols.cloud_rounded,
                size: 16,
                fill: 1,
                color: context.colorScheme.primary,
              ),
              Text(data.server),
            ],
          ),
          if (!data.isStatic)
            FTextButton(
              onPressed: changeServer,
              value: context.l10n.login_page__change_server,
            ),
        ],
      ),
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: FTextFormField(
              label: context.l10n.login_username_text_field__label,
              controller: _usernameController,
              onFieldSubmitted: (_) => openLoginPage(),
              onChanged: ref.read(pAuthUsernameProvider.notifier).set,
              validators: (input) =>
                  UValidatorPresets.isNotEmpty(context, input),
              autofillHints: const [AutofillHints.username],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            if (data.enableRegistration)
              M3EButton(
                style: .text,
                onPressed: () => context.routes.registration(),
                child: Text(context.l10n.auth_page__register),
              ),
            const SizedBox.shrink(),
            M3EButton(
              onPressed: openLoginPage,
              child: Text(context.l10n.btn_continue),
            ),
          ],
        ),
        if (data.oidcProviders.isNotEmpty)
          Column(
            mainAxisSize: .min,
            children: [
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
              SizedBox(
                width: BUTTON_WIDTH,
                child: FTileGroup(
                  backgroundColor: context.colorScheme.primaryContainer,
                  items: [
                    for (final provider in data.oidcProviders)
                      FTile(
                        label: provider.label,
                        leading: FOidcIcon(
                          data: provider.icon,
                          label: provider.label,
                        ),
                        onTap: () => openOIDC(provider),
                      ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Center(
      child: FResponsiveCard(
        child: Column(
          crossAxisAlignment: .start,
          spacing: PADDING * 1.5,
          children: [
            FLogo.sm,
            FText(
              context.l10n.auth_page__no_connection,
              style: FTextStyle.headlineMedium,
              fontRoundness: 100,
            ),
            FText(
              context.l10n.splash_page__on_error,
              style: FTextStyle.bodyMedium,
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const SizedBox.shrink(),
                M3EButton(
                  style: .tonal,
                  onPressed: changeServer,
                  child: Text(context.l10n.login_page__change_server),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openLoginPage() async {
    if (!_formKey.currentState!.validate()) return;

    await context.routes.login();
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
        context.l10n.auth_page__oidc_error(provider.label),
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
