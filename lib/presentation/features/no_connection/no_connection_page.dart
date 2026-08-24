import 'dart:async';

import 'package:flavormate/core/apis/rest/p_dio_public.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/api_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

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
                  const Icon(Symbols.cloud_off_rounded, size: 128),
                  FText(
                    context.l10n.no_connection_page__hint_1,
                    style: FTextStyle.titleLarge,
                  ),
                  FText(
                    context.l10n.no_connection_page__hint_2,
                    style: FTextStyle.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  M3EButton(
                    onPressed: logout,
                    child: Text(context.l10n.btn_logout),
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
