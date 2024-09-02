import 'dart:async';

import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/api/p_api.dart';
import 'package:flavormate/riverpod/auth_state/p_auth_state.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoConnectionPage extends ConsumerStatefulWidget {
  const NoConnectionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NoConnectionPageState();
}

class _NoConnectionPageState extends ConsumerState<NoConnectionPage> {
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        await ref.read(pApiProvider).userClient.getUser();
        ref.read(pGoRouterProvider).goNamed('home');
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
    return Scaffold(
      body: Center(
        child: TColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              MdiIcons.cloudOffOutline,
              size: 128,
            ),
            TText(
              L10n.of(context).p_no_connection_title,
              TextStyles.titleLarge,
            ),
            TText(
              L10n.of(context).p_no_connection_subtitle,
              TextStyles.titleSmall,
              textAlign: TextAlign.center,
            ),
            FilledButton(
              onPressed: () => ref.read(pAuthStateProvider.notifier).logout(),
              child: Text(L10n.of(context).btn_logout),
            ),
          ],
        ),
      ),
    );
  }
}
