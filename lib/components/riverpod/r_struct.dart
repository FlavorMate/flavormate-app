import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RStruct<T> extends StatelessWidget {
  final AsyncValue<T> provider;
  final Widget Function(BuildContext, T) builder;
  final Widget? loadingChild;
  final Widget? errorChild;

  const RStruct(
    this.provider,
    this.builder, {
    this.loadingChild,
    this.errorChild,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return switch (provider) {
      AsyncData(value: final value) => builder(context, value),
      AsyncError(:final error) => errorChild ?? Text('$error'),
      _ => loadingChild ?? const Center(child: CircularProgressIndicator()),
    };
  }
}
