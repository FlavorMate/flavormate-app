import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error_page.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProviderPage<T> extends ConsumerWidget {
  final bool loadingShowAppBar;
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(BuildContext, T) builder;
  final Widget Function(BuildContext, T)? bottomNavigationBarBuilder;
  final Widget Function(BuildContext, T)? floatingActionButtonBuilder;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget Function(BuildContext, T)? appBarBuilder;
  final FEmptyMessage onError;

  const FProviderPage({
    required this.provider,
    required this.builder,
    required this.onError,
    this.bottomNavigationBarBuilder,
    this.floatingActionButtonBuilder,
    this.floatingActionButtonLocation,
    this.appBarBuilder,
    this.loadingShowAppBar = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return switch (state) {
      AsyncData(value: final value) => Scaffold(
        appBar: appBarBuilder?.call(context, value),
        body: SafeArea(child: builder(context, value)),
        bottomNavigationBar: getBottomNavigationBar(context, value),
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingActionButtonBuilder?.call(
          context,
          value,
        ),
      ),
      AsyncError() => FErrorPage(
        onError: onError,
        showAppBar: loadingShowAppBar,
      ),
      _ => FLoadingPage(showAppBar: loadingShowAppBar),
    };
  }

  Widget? getBottomNavigationBar(BuildContext context, T value) {
    if (bottomNavigationBarBuilder == null) return null;

    return SafeArea(child: bottomNavigationBarBuilder!.call(context, value));
  }
}
