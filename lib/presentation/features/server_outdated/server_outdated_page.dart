import 'dart:async';

import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/data/repositories/core/server/p_server_compatibility.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServerOutdatedPage extends ConsumerStatefulWidget {
  const ServerOutdatedPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ServerOutdatedPageState();
}

class _ServerOutdatedPageState extends ConsumerState<ServerOutdatedPage> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 5),
      _checkIfServerIsCompatible,
    );

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final server = ref.read(pSPCurrentServerProvider);
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(PADDING),
        child: Stack(
          children: [
            Center(
              child: Column(
                spacing: PADDING,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(MdiIcons.cloudAlertOutline, size: 128),
                  FText(
                    L10n.of(context).server_outdated_page__hint_1,
                    style: FTextStyle.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  FText(
                    L10n.of(context).server_outdated_page__hint_2,
                    style: FTextStyle.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  FilledButton(
                    onPressed: logout,
                    child: Text(L10n.of(context).btn_logout),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: PADDING,
              right: PADDING,
              child: FText('☁ $server', style: FTextStyle.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    await ref.read(pAuthProvider.notifier).logout();
  }

  Future<void> _checkIfServerIsCompatible(Timer timer) async {
    final response = await ref.read(pServerCompatibilityProvider.future);

    if (response != VersionComparison.majorIncompatible && mounted) {
      await context.routes.splash(replace: true);
    }
  }
}
