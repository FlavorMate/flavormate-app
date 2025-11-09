import 'dart:async';

import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_current_server.dart';
import 'package:flavormate/data/models/core/version/version.dart';
import 'package:flavormate/data/repositories/core/compatibility/p_compatibility.dart';
import 'package:flavormate/data/repositories/core/features/p_features.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_unit_conversions.dart';
import 'package:flavormate/data/repositories/features/units/p_rest_units.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
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

  // for debug purposes
  int _showError = 0;
  dynamic error;

  @override
  void initState() {
    ref.listenManual(
      pCompatibilityProvider,
      (_, next) async => await next.when(
        data: (comparison) async {
          if (!mounted) return;

          await ref.read(pFeaturesProvider.future);
          await ref.read(pRestUnitsProvider(pageSize: -1).future);
          await ref.read(pRestUnitConversionsProvider.future);

          if (!mounted) return;
          switch (comparison) {
            case VersionComparison.majorIncompatible:
              context.routes.serverOutdated();
              return;
            case VersionComparison.minorIncompatible:
              context.routes.home(replace: true);
              return;
            case VersionComparison.fullyCompatible:
              context.routes.home(replace: true);
              return;
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
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
    final compatibilityState = ref.watch(pCompatibilityProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: PADDING,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FLogo(size: 160),
              FText(
                L10n.of(context).flavormate,
                style: FTextStyle.headlineLarge,
              ),
              const SizedBox(height: 16),
              compatibilityState.when(
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
          height: 64,
          child: AnimatedOpacity(
            opacity: _showLogout ? 1 : 0,
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                FText(
                  L10n.of(context).splash_page__hint_1,
                  style: FTextStyle.bodyMedium,
                ),
                SizedBox(
                  width: 250,
                  child: FDenseTextButton(
                    onPressed: logout,
                    child: Text(L10n.of(context).btn_logout),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Column(
      children: [
        const CircularProgressIndicator(),
        FText(
          L10n.of(context).splash_page__loading,
          style: FTextStyle.titleLarge,
        ),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, dynamic error) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _showError += 1),
          child: SizedBox(
            width: 250,
            child: FText(
              L10n.of(context).splash_page__on_error,
              style: FTextStyle.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (_showError >= 5)
          SizedBox(
            height: 150,
            child: SingleChildScrollView(child: Text('$error')),
          ),
      ],
    );
  }

  Future<void> logout() async {
    await ref.read(pAuthProvider.notifier).logout();
    await ref.read(pSPCurrentServerProvider.notifier).set(null);
  }
}
