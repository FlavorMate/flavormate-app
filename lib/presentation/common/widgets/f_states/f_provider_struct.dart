import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProviderStruct<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<T>> provider;
  final Widget Function(BuildContext, T) builder;
  final FEmptyMessage onError;

  const FProviderStruct({
    required this.provider,
    required this.builder,
    required this.onError,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return switch (state) {
      AsyncData(value: final value) => builder(
        context,
        value,
      ),
      AsyncError() => FError(onError: onError),
      _ => const FLoading(),
    };
  }
}
