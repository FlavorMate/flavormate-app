import 'dart:async';

import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/version/version.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/features/p_compatibility.dart';
import 'package:flavormate/riverpod/features/p_features.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/shared_preferences/p_server.dart';
import 'package:flavormate/utils/constants.dart';
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
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        ref.invalidate(pFeaturesProvider);
        final response = await ref.read(
          pCompatibilityProvider.selectAsync((data) => data),
        );

        if (response != VersionComparison.majorIncompatible && mounted) {
          ref.read(pGoRouterProvider).goNamed('splash');
        }
      } catch (_) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final server = ref.read(pServerProvider);
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(PADDING),
        child: Stack(
          children: [
            Center(
              child: TColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(MdiIcons.cloudAlertOutline, size: 128),
                  TText(
                    L10n.of(context).p_server_outdated_title,
                    TextStyles.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  TText(
                    L10n.of(context).p_server_outdated_subtitle,
                    TextStyles.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  FilledButton(
                    onPressed: () =>
                        ref.read(pAuthStateProvider.notifier).logout(),
                    child: Text(L10n.of(context).btn_logout),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: PADDING,
              right: PADDING,
              child: TText('☁ $server', TextStyles.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
