import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FProviderBuilder<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<PageableDto<T>>> provider;
  final FEmptyMessage onEmpty;
  final FEmptyMessage onError;
  final Widget Function(PageableDto<T>) builder;

  const FProviderBuilder({
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
      return FError(onError: onError);
    } else if (!state.hasValue && state.isLoading) {
      return const FLoading();
    } else {
      if (state.value?.data.isEmpty ?? true) {
        return Center(child: onEmpty);
      } else {
        return builder.call(state.value!);
      }
    }
  }
}
