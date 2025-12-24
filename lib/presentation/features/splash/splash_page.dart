import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/config/app_links/p_app_links.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/data/repositories/core/server/p_server_compatibility.dart';
import 'package:flavormate/data/repositories/core/server/p_server_features.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_unit_conversions.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_units.dart';
import 'package:flavormate/presentation/common/widgets/f_dense_text_button.dart';
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  Timer? _timer;
  bool _showLogout = false;

  @override
  void initState() {
    ref.listenManual(
      pServerCompatibilityProvider,
      (_, next) async => await next.when(
        data: (comparison) async {
          if (!mounted) return;

          await ref.read(pServerFeaturesProvider.future);
          await ref.read(pRestUnitsProvider(pageSize: -1).future);
          await ref.read(pRestUnitConversionsProvider.future);

          if (!mounted) return;
          switch (comparison) {
            case VersionComparison.majorIncompatible:
              context.routes.serverOutdated();
              return;
            case VersionComparison.minorIncompatible:
            case VersionComparison.fullyCompatible:
              final appLink = AppLinks();
              final latestAppLink = await appLink.getLatestLink();

              if (!mounted) return;
              if (latestAppLink != null) {
                await ref
                    .read(pAppLinksProvider.notifier)
                    .listener(latestAppLink);
              } else {
                await context.routes.home(replace: true);
              }
          }
        },
        loading: () {},
        error: (_, _) async {
          if (next.isLoading) return;
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          ref.invalidate(pServerCompatibilityProvider);
        },
      ),
      fireImmediately: true,
    );

    _timer = Timer(
      const Duration(seconds: 5),
      () => setState(() => _showLogout = true),
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
    final compatibilityState = ref.watch(pServerCompatibilityProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: PADDING,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FLogo(size: 160),
              FText(
                context.l10n.flavormate,
                style: FTextStyle.headlineLarge,
              ),
              const SizedBox(height: PADDING),
              ...compatibilityState.when(
                data: (_) => _buildLoadingWidget(context),
                error: (error, _) => _buildErrorWidget(context, error),
                loading: () => _buildLoadingWidget(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 76,
          child: AnimatedOpacity(
            opacity: _showLogout ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Column(
              spacing: PADDING / 2,
              children: [
                FText(
                  context.l10n.splash_page__hint_1,
                  style: FTextStyle.bodyMedium,
                ),
                SizedBox(
                  width: 250,
                  child: FDenseTextButton(
                    onPressed: logout,
                    child: Text(context.l10n.btn_logout),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoadingWidget(BuildContext context) {
    return [
      const CircularProgressIndicator(),
      FText(
        context.l10n.splash_page__loading,
        style: FTextStyle.titleLarge,
      ),
    ];
  }

  List<Widget> _buildErrorWidget(BuildContext context, dynamic error) {
    return [
      SizedBox(
        width: 250,
        child: FText(
          context.l10n.splash_page__on_error,
          style: FTextStyle.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  Future<void> logout() async {
    await ref.read(pAuthProvider.notifier).logout();
    await ref.read(pSPCurrentServerProvider.notifier).set(null);
  }
}
