import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProviderState2Sliver<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<List<T>>> provider;
  final FEmptyMessage onEmpty;
  final FEmptyMessage onError;
  final Widget Function(List<T>) builder;

  const FProviderState2Sliver({
    required this.provider,
    required this.onEmpty,
    required this.onError,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    if (state.hasError) {
      return SliverToBoxAdapter(child: FError(onError: onError));
    } else if (state.isLoading || state.value == null) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state.value!.isEmpty) {
      return SliverToBoxAdapter(
        child: FError(onError: onEmpty),
      );
    } else {
      return SliverToBoxAdapter(
        child: FError(onError: onEmpty),
      );
      return builder(state.value!);
    }
  }
}
