import 'package:flavormate/components/t_button.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/gen/assets.gen.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
import 'package:flavormate/utils/u_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerForm extends ConsumerStatefulWidget {
  final bool readOnly;

  const ServerForm({required this.readOnly, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServerFormState();
}

class _ServerFormState extends ConsumerState<ServerForm> {
  final _serverFormKey = GlobalKey<FormState>();

  final _serverController = TextEditingController();

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: TextButton.icon(
          onPressed: openHelp,
          icon: const Icon(MdiIcons.helpCircleOutline),
          label: Text(L10n.of(context).p_login_create_server),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(PADDING),
              constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
              child: Form(
                key: _serverFormKey,
                child: Column(
                  children: [
                    Assets.icons.logoTransparent.image(width: 128, height: 128),
                    const TText('FlavorMate', TextStyles.headlineLarge),
                    const SizedBox(height: PADDING * 2),
                    TextFormField(
                      enabled: !widget.readOnly,
                      readOnly: widget.readOnly,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(L10n.of(context).p_login_server),
                      ),
                      controller: _serverController,
                      validator: (value) {
                        if (!UValidator.isHttpUrl(value ?? '')) {
                          return L10n.of(context).v_isHttpUrl;
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: PADDING),
                    SizedBox(
                      width: 128,
                      child: TButton(
                        onPressed: setServer,
                        label: L10n.of(context).btn_continue,
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

  void setServer() {
    if (!_serverFormKey.currentState!.validate()) return;

    ref.read(pServerProvider.notifier).set(_serverController.text);
  }

  void openHelp() async {
    final uri = Uri.parse(FLAVORMATE_GETTING_STARTED);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    }
  }
}
