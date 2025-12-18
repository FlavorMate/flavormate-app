import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/core/cache/provider/p_cached_image_manager.dart';
import 'package:flavormate/core/config/app_links/p_app_links.dart';
import 'package:flavormate/core/mappers/custom_mappers.dart';
import 'package:flavormate/core/navigation/p_go_router.dart';
import 'package:flavormate/core/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/core/storage/root_bundle/backend_url/p_rb_backend_url.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp.dart';
import 'package:flavormate/core/storage/shared_preferences/providers/p_sp_theme_tone.dart';
import 'package:flavormate/core/theme/models/f_theme.dart';
import 'package:flavormate/core/theme/providers/p_theme.dart';
import 'package:flavormate/core/extensions/e_build_context.dart';
import 'package:flavormate/generated/l10n/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ImageCache;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerManualLicenses();
  await SystemTheme.accentColor.load();
  MapperContainer.globals.useAll(customMappers);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  runApp(
    ProviderScope(
      retry: (_, _) => null,
      child: const _EagerInitialization(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pGoRouterProvider);

    final tone = ref.watch(pSPThemeToneProvider);
    final color = ref.watch(pThemeProvider).requireValue;

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.flavormate,
      theme: FTheme.createTheme(color, .light, tone.tone),
      darkTheme: FTheme.createTheme(color, .dark, tone.tone),
      themeMode: ThemeMode.system,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: provider,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pAppLinksProvider);
    final values = [
      ref.watch(pSPProvider),
      ref.watch(pRBBackendUrlProvider),
      ref.watch(pThemeProvider),
      ref.watch(pPackageInfoProvider),
      ref.watch(pCachedImageManagerProvider),
    ];

    if (values.every((value) => value.hasValue)) {
      ref.read(pCachedImageManagerProvider.notifier).housekeeping();
      return child;
    }

    return const SizedBox();
  }
}

void registerManualLicenses() async {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['FlavorMate App'],
      await rootBundle.loadString('LICENSE.txt'),
    );
  });

  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['Google Sans Code'],
      await rootBundle.loadString('assets/fonts/Google_Sans_Code/OFL.txt'),
    );
  });

  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['Google Sans Flex'],
      await rootBundle.loadString('assets/fonts/Google_Sans_Flex/OFL.txt'),
    );
  });
}
