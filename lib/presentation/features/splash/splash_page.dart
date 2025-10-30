import 'dart:async';

import 'package:flavormate/core/auth/providers/p_auth.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
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
  bool _isError = false;

  @override
  void initState() {
    ref
        .read(pCompatibilityProvider.future)
        .then((data) async {
          if (!mounted) return;

          await ref.read(pFeaturesProvider.future);
          await ref.read(pRestUnitsProvider(pageSize: -1).future);
          await ref.read(pRestUnitConversionsProvider.future);

          if (!mounted) return;
          switch (data) {
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
        })
        .catchError((e) {
          _isError = true;
        });

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
              if (!_isError) ...[
                const CircularProgressIndicator(),
                FText(
                  L10n.of(context).splash_page__loading,
                  style: FTextStyle.titleLarge,
                ),
              ] else
                SizedBox(
                  width: 250,
                  child: FText(
                    L10n.of(context).splash_page__on_error,
                    style: FTextStyle.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
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

  Future<void> logout() async {
    return ref.read(pAuthProvider.notifier).logout();
  }
}
