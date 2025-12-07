import 'dart:math';

import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_empty_message.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_error.dart';
import 'package:flavormate/presentation/common/widgets/f_states/f_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FPaginatedContent<T> extends ConsumerWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final ScrollController controller;

  final FEmptyMessage onError;
  final FEmptyMessage onEmpty;

  final Widget Function(T item) itemBuilder;

  const FPaginatedContent({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.controller,
    required this.onEmpty,
    required this.onError,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(provider);

    if (dataState.isLoading) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: FLoading(),
      );
    } else if (dataState.hasError) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: FError(onError: onError),
      );
    }

    final data = dataState.value!;

    if (data.data.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: onEmpty,
        ),
      );
    }

    return SliverPadding(
      padding: const .symmetric(horizontal: PADDING),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final resolution = constraints.crossAxisExtent;

          final int count = (resolution / 355).floor();

          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: max(1, count),
              mainAxisSpacing: PADDING,
              crossAxisSpacing: PADDING,
              childAspectRatio: 16 / 9,
            ),
            itemCount: data.data.length,
            itemBuilder: (context, index) {
              final item = data.data[index];
              return itemBuilder.call(item);
            },
          );
        },
      ),
    );
  }
}
