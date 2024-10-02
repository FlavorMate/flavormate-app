import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RFeature extends StatelessWidget {
  final AsyncValue<bool> provider;
  final Widget Function(BuildContext) builder;
  final Widget? loadingChild;
  final Widget? errorChild;

  const RFeature(
    this.provider,
    this.builder, {
    this.loadingChild,
    this.errorChild,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RStruct(
      provider,
      (ctx, visible) => Visibility(
        visible: visible,
        child: builder(ctx),
      ),
      loadingChild: loadingChild,
      errorChild: errorChild,
    );
  }
}
