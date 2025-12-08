import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/root_bundle/backend_url/p_rb_backend_url.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_recent_servers.dart';
import 'package:flavormate/presentation/common/widgets/f_button.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flavormate/presentation/common/widgets/f_wrap.dart';
import 'package:flavormate/presentation/features/server/widgets/server_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ServerPage extends ConsumerStatefulWidget {
  const ServerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServerPageState();
}

class _ServerPageState extends ConsumerState<ServerPage> {
  final _serverFormKey = GlobalKey<FormState>();
  final _serverController = TextEditingController();

  @override
  void dispose() {
    _serverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final readOnly = ref.watch(pRBBackendUrlProvider).requireValue != null;
    final recentServers = ref.watch(pSPRecentServersProvider);

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 48,
          child: Center(
            child: TextButton.icon(
              onPressed: openHelp,
              icon: const Icon(MdiIcons.helpCircleOutline),
              label: Text(context.l10n.server_page__create_server),
            ),
          ),
        ),
      ),
      body: Center(
        child: FResponsive(
          child: Form(
            key: _serverFormKey,
            child: Column(
              children: [
                const FLogo(size: 128),
                const FText(FLAVORMATE, style: FTextStyle.headlineLarge),
                const SizedBox(height: PADDING * 2),
                ServerTextField(
                  controller: _serverController,
                  readOnly: readOnly,
                  setServer: setServer,
                ),
                const SizedBox(height: PADDING),
                FWrap(
                  children: [
                    if (recentServers.isNotEmpty)
                      SizedBox(
                        width: 160,
                        child: FButton(
                          tonal: true,
                          onPressed: () => pickServer(recentServers),
                          label: context.l10n.server_page__recent_servers,
                        ),
                      ),
                    SizedBox(
                      width: 125,
                      child: FButton(
                        onPressed: setServer,
                        label: context.l10n.btn_continue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setServer() async {
    if (!_serverFormKey.currentState!.validate()) return;

    await ref
        .read(pSPCurrentServerProvider.notifier)
        .set(_serverController.text);

    if (!mounted) return;
    context.routes.login(replace: true);
  }

  void pickServer(List<String> recentServers) async {
    final response = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          context.l10n.server_page__recent_servers,
        ),
        children: [
          for (final server in recentServers)
            SimpleDialogOption(
              child: Text(server),
              onPressed: () => context.pop(server),
            ),
        ],
      ),
    );

    if (!context.mounted || response == null) return;
    _serverController.text = response;
    setServer();
  }

  void openHelp() async {
    final uri = Uri.parse(FLAVORMATE_GETTING_STARTED);

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
