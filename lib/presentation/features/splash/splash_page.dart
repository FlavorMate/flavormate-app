import 'dart:async';

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
import 'package:flavormate/presentation/common/widgets/f_logo.dart';
import 'package:flavormate/presentation/common/widgets/f_responsive_card.dart';
import 'package:flavormate/presentation/common/widgets/f_text/f_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/loading_indicator/m3e_loading_indicator.dart';
import 'package:material_ui/material_ui.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
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
              final latestAppLink = await ref
                  .read(pAppLinksProvider.notifier)
                  .getInitialUri();

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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compatibilityState = ref.watch(pServerCompatibilityProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FResponsiveCard(
            child: SizedBox(
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: const .new(milliseconds: 250),
                child: compatibilityState.when(
                  data: (_) => _buildLoadingWidget(context),
                  error: (error, _) => _buildErrorWidget(context, error),
                  loading: () => _buildLoadingWidget(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return const Center(child: M3ELoadingIndicator());
  }

  Widget _buildErrorWidget(BuildContext context, dynamic error) {
    return Column(
      crossAxisAlignment: .start,
      spacing: PADDING * 1.5,
      children: [
        FLogo.sm,
        // TODO: L10n
        const FText(
          'Keine Verbindung',
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
              onPressed: logout,
              child: Text(context.l10n.btn_logout),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> logout() async {
    await ref.read(pAuthProvider.notifier).logout();
    await ref.read(pSPCurrentServerProvider.notifier).set(null);
  }
}
