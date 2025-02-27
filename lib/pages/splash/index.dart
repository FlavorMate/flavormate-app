import 'package:flavormate/components/t_column.dart';
import 'package:flavormate/components/t_image.dart';
import 'package:flavormate/components/t_text.dart';
import 'package:flavormate/gen/assets.gen.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/models/version/version.dart';
import 'package:flavormate/riverpod/features/p_compatibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  Widget build(BuildContext context) {
    ref.read(pCompatibilityProvider.selectAsync((data) => data)).then((data) {
      if (!context.mounted) return;

      switch (data) {
        case VersionComparison.majorIncompatible:
          return context.replaceNamed('server-outdated');
        case VersionComparison.minorIncompatible:
          return context.replaceNamed('home');
        case VersionComparison.fullyCompatible:
          return context.replaceNamed('home');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TImage(
                imageSrc: Assets.icons.logoTransparent.path,
                type: TImageType.asset,
                height: 160,
                width: 160,
              ),
              TText(L10n.of(context).app_title, TextStyles.headlineLarge),
              SizedBox(height: 16),
              CircularProgressIndicator(),
              TText(L10n.of(context).p_splash_loading, TextStyles.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
