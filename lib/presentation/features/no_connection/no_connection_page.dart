import 'dart:async';

import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
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
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      _checkIfServerIsAvailable,
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final server = ref.watch(pSPCurrentServerProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                spacing: PADDING,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(MdiIcons.cloudOffOutline, size: 128),
                  FText(
                    L10n.of(context).no_connection_page__hint_1,
                    style: FTextStyle.titleLarge,
                  ),
                  FText(
                    L10n.of(context).no_connection_page__hint_2,
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

  Future<void> _checkIfServerIsAvailable(Timer timer) async {
    try {
      await ref.read(pDioPublicProvider).get(ApiConstants.Features);

      if (!mounted) return;
      await context.routes.home(replace: true);
    } catch (_) {
      // Server is still unavailable. Wait for another 5 seconds
    }
  }
}
