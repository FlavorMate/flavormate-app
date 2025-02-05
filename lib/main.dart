import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/app_links/p_app_links.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/riverpod/root_bundle/p_backend_url.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/riverpod/theme/p_theme.dart';
import 'package:flavormate/utils/custom_mappers/custom_mappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  MapperContainer.globals.useAll(customMappers);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent),
  );

  runApp(const ProviderScope(child: _EagerInitialization(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pGoRouterProvider);
    final colors = ref.watch(pThemeProvider).requireValue;
    return MaterialApp.router(
      onGenerateTitle: (context) => L10n.of(context).app_title,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: colors.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: colors.dark,
        useMaterial3: true,
      ),
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
    ref.read(pAppLinksProvider);
    final values = [
      ref.watch(pPackageInfoProvider),
      ref.watch(pSharedPreferencesProvider),
      ref.watch(pBackendUrlProvider),
      ref.watch(pThemeProvider),
    ];

    if (values.every((value) => value.hasValue)) {
      return child;
    }

    return const SizedBox();
  }
}
