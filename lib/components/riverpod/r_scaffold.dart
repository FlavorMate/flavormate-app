import 'package:flavormate/components/riverpod/error_page.dart';
import 'package:flavormate/components/riverpod/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RScaffold<T> extends StatelessWidget {
  final AsyncValue<T> provider;
  final Widget Function(BuildContext, T) builder;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const RScaffold(
    this.provider, {
    required this.builder,
    this.appBar,
    this.floatingActionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (provider) {
      AsyncData(value: final value) => Scaffold(
          appBar: appBar,
          body: SafeArea(child: builder(context, value)),
          floatingActionButton: floatingActionButton,
        ),
      AsyncError(:final error) => ErrorPage(error.toString()),
      _ => const LoadingPage(),
    };
  }
}
