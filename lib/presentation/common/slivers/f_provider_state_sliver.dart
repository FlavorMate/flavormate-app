import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProviderStateSliver<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<PageableDto<T>>> provider;
  final FEmptyMessage onEmpty;
  final FEmptyMessage onError;
  final Widget child;

  const FProviderStateSliver({
    required this.provider,
    required this.onEmpty,
    required this.onError,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);

    if (state.hasError) {
      return SliverToBoxAdapter(child: FError(onError: onError));
    } else {
      if (state.value?.data.isEmpty ?? false) {
        return SliverToBoxAdapter(child: Center(child: onEmpty));
      } else {
        return child;
      }
    }
  }
}
