import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_pageable_bar.dart';
import 'package:flavormate/components/t_pageable_content.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TPageable<T> extends ConsumerStatefulWidget {
  final AutoDisposeAsyncNotifierProvider<dynamic, Pageable<T>> provider;
  final AutoDisposeNotifierProvider<AutoDisposeNotifier<int>, int> pageProvider;
  final Widget Function(BuildContext, Pageable<T>) builder;
  final void Function(WidgetRef, int) onPressed;
  final Widget onEmpty;

  const TPageable({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.builder,
    required this.onPressed,
    required this.onEmpty,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TPageableState<T>();
}

class _TPageableState<T> extends ConsumerState<TPageable<T>> {
  int _totalPages = 1;

  @override
  void initState() {
    ref.listenManual(widget.provider, fireImmediately: true, (_, value) {
      if (!value.hasValue) return;
      _totalPages = value.value!.page.totalPages;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(widget.provider);
    final pageProvider = ref.watch(widget.pageProvider);
    return Column(
      children: [
        Expanded(
          child: RStruct(
            provider,
            (context, value) => value.content.isEmpty
                ? Center(child: widget.onEmpty)
                : TPageableContent(
                    child: widget.builder(context, value),
                  ),
          ),
        ),
        TPageableBar(
          totalPages: _totalPages,
          onPressed: (int value) => widget.onPressed(ref, value),
          currentPage: pageProvider,
        ),
      ],
    );
  }
}
