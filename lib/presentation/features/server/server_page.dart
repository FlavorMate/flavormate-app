import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/root_bundle/backend_url/p_rb_backend_url.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_recent_servers.dart';
import 'package:flavormate/presentation/common/dialogs/f_alert_dialog.dart';
import 'package:flavormate/presentation/common/layouts/auth_page_template.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_group.dart';
import 'package:flavormate/presentation/common/widgets/f_tile_group/f_tile_icon.dart';
import 'package:flavormate/presentation/features/server/widgets/server_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
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

    return AuthPageTemplate(
      title: context.l10n.server_page__title,
      subtitle: context.l10n.server_page__hint,
      bottomChild: M3EButton.icon(
        style: .text,
        onPressed: openHelp,
        icon: const Icon(Symbols.help_rounded),
        label: Text(context.l10n.server_page__create_server),
      ),
      children: [
        Form(
          key: _serverFormKey,
          child: ServerTextField(
            controller: _serverController,
            readOnly: readOnly,
            setServer: setServer,
          ),
        ),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            if (recentServers.isNotEmpty)
              M3EIconButton(
                onPressed: () => pickServer(recentServers),
                icon: const Icon(Symbols.history_rounded),
              ),
            const SizedBox.shrink(),
            M3EButton(
              onPressed: setServer,
              child: Text(context.l10n.btn_continue),
            ),
          ],
        ),
      ],
    );
  }

  void setServer() async {
    if (!_serverFormKey.currentState!.validate()) return;

    await ref
        .read(pSPCurrentServerProvider.notifier)
        .set(_serverController.text);

    if (!mounted) return;
    context.routes.auth(replace: true);
  }

  void pickServer(List<String> recentServers) async {
    final response = await openAlertDialog(
      context,
      dialog: M3EDialog(
        title: context.l10n.server_page__recent_servers,
        bottomDivider: true,
        topDivider: true,
        content: FTileGroup(
          items: [
            for (final server in recentServers)
              FTile(
                leading: const FTileIcon(icon: Symbols.bookmark_rounded),
                label: server,
                onTap: () => context.pop(server),
              ),
          ],
        ),
        actions: [
          M3EButton.text(
            onPressed: () => context.pop(),
            child: Text(context.l10n.btn_close),
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
