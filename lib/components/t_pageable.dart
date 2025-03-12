import 'package:flavormate/components/riverpod/r_struct.dart';
import 'package:flavormate/components/t_pageable_bar.dart';
import 'package:flavormate/components/t_pageable_content.dart';
import 'package:flavormate/interfaces/a_base_page_provider.dart';
import 'package:flavormate/models/pageable/pageable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TPageable<T, N extends BasePageProvider> extends ConsumerStatefulWidget {
  final AutoDisposeAsyncNotifierProvider<dynamic, Pageable<T>> provider;
  final AutoDisposeNotifierProvider<N, int> pageProvider;
  final Widget Function(BuildContext, Pageable<T>) builder;
  final Widget onEmpty;

  const TPageable({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.builder,
    required this.onEmpty,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TPageableState<T, N>();
}

class _TPageableState<T, N extends BasePageProvider>
    extends ConsumerState<TPageable<T, N>> {
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
            (context, value) =>
                value.content.isEmpty
                    ? Center(child: widget.onEmpty)
                    : TPageableContent(child: widget.builder(context, value)),
          ),
        ),
        TPageableBar(
          totalPages: _totalPages,
          onPressed: (int value) => setPage(value),
          currentPage: pageProvider,
        ),
      ],
    );
  }

  void setPage(int value) {
    ref.read(widget.pageProvider.notifier).setState(value);
  }
}
