import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FSliverList<T> extends ConsumerStatefulWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final ScrollController scrollController;

  final Widget Function(T data, int index, bool first, bool last) itemBuilder;

  const FSliverList({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.scrollController,
    required this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FSliverList<T>();
}

class _FSliverList<T> extends ConsumerState<FSliverList<T>> {
  bool _loadingInProgress = true;

  final List<T> _data = [];

  @override
  void initState() {
    ref.listenManual(widget.provider, (_, asyncData) {
      final value = asyncData.value;
      if (value == null) return;

      setState(() {
        _loadingInProgress = false;

        _data.clear();
        _data.addAll(value.data);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList.separated(
          itemCount: _data.length,
          separatorBuilder: (_, _) => const SizedBox(height: PADDING / 4),
          itemBuilder: (context, index) => widget.itemBuilder.call(
            _data[index],
            index,
            index == 0,
            index == _data.length - 1,
          ),
        ),
        if (_loadingInProgress)
          const SliverPadding(
            padding: .all(PADDING),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
