import 'package:dart_mappable/dart_mappable.dart';
import 'package:flavormate/l10n/generated/l10n.dart';
import 'package:flavormate/riverpod/go_router/p_go_router.dart';
import 'package:flavormate/riverpod/package_info/p_package_info.dart';
import 'package:flavormate/riverpod/shared_preferences/p_shared_preferences.dart';
import 'package:flavormate/utils/custom_mappers/custom_mappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapperContainer.globals.useAll(customMappers);
  runApp(const ProviderScope(child: _EagerInitialization(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(pGoRouterProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => L10n.of(context).app_title,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.lightGreen,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.lightGreen,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      routerConfig: provider,
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final values = [
      ref.watch(pPackageInfoProvider),
      ref.watch(pSharedPreferencesProvider),
    ];

    if (values.every((value) => value.hasValue)) {
      return child;
    }

    return const SizedBox();
  }
}
