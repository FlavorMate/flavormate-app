import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/loading_indicator/m3e_loading_indicator.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FLazySliverGrid<T> extends ConsumerStatefulWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final ScrollController scrollController;

  final double rowHeight;

  final Widget Function(
    T data, {
    required int index,
    required bool topLeft,
    required bool topRight,
    required bool bottomLeft,
    required bool bottomRight,
  })
  itemBuilder;

  const FLazySliverGrid({
    required super.key,
    required this.provider,
    required this.pageProvider,
    required this.scrollController,
    required this.rowHeight,
    required this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FLazySliverGrid<T>();
}

class _FLazySliverGrid<T> extends ConsumerState<FLazySliverGrid<T>> {
  int _currentPage = -1;
  int _maxPages = 0;

  bool _loadingInProgress = true;

  final List<T> _data = [];

  static const double _loadMoreThresholdPx = 50;

  ScrollPosition get _scrollPosition => widget.scrollController.position;

  double get _loadMoreTriggerOffset =>
      _scrollPosition.maxScrollExtent - _loadMoreThresholdPx;

  bool get _hasScrollableContent => _scrollPosition.maxScrollExtent > 0;

  bool get _listAtEnd => _scrollPosition.pixels >= _loadMoreTriggerOffset;

  @override
  void initState() {
    ref.listenManual(widget.provider, fireImmediately: true, (_, asyncData) {
      if (asyncData.isLoading) return;

      final value = asyncData.value;
      if (value == null) return;

      final metadata = value.metadata;
      final nextPage = metadata.currentPage;

      if (_currentPage == nextPage) return;

      setState(() {
        _loadingInProgress = false;
        _currentPage = nextPage;
        _maxPages = metadata.totalPages;

        if (nextPage == 0) {
          _data.clear();
        }

        _data.addAll(value.data);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_hasScrollableContent) {
            _loadMoreItems();
          }
        });
      });
    });

    widget.scrollController.addListener(_onScrollMaybeLoadMore);

    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScrollMaybeLoadMore);
    super.dispose();
  }

  void _onScrollMaybeLoadMore() {
    final shouldLoadMore = _listAtEnd && _hasScrollableContent;
    if (shouldLoadMore) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    final canLoadMore =
        !_loadingInProgress && _maxPages > 0 && _currentPage < _maxPages;

    if (!canLoadMore) return;

    setState(() => _loadingInProgress = true);

    ref.read(widget.pageProvider.notifier).increment();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).listTheme.cardList;
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.crossAxisExtent + 2 * PADDING;
        final crossAxisCount = switch (parentWidth) {
          >= FBreakpoint.mdValue => 2,
          >= FBreakpoint.smValue => 2,
          _ => 1,
        };

        return SliverMainAxisGroup(
          slivers: [
            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _data.length == 1 ? 1 : crossAxisCount,
                mainAxisExtent: widget.rowHeight,
                mainAxisSpacing: theme.gap,
                crossAxisSpacing: theme.gap,
              ),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final effectiveCrossAxisCount = _data.length == 1
                    ? 1
                    : crossAxisCount;

                final columnIndex = index % effectiveCrossAxisCount;
                final isFirstRow = index < effectiveCrossAxisCount;
                final hasItemBelow =
                    index + effectiveCrossAxisCount < _data.length;
                final hasItemToRight =
                    columnIndex < effectiveCrossAxisCount - 1 &&
                    index + 1 < _data.length;

                final topLeft = index == 0;
                final topRight = isFirstRow && !hasItemToRight;
                final bottomLeft = !hasItemBelow && columnIndex == 0;
                final bottomRight = !hasItemBelow && !hasItemToRight;

                return widget.itemBuilder.call(
                  _data[index],
                  index: index,
                  topLeft: topLeft,
                  topRight: topRight,
                  bottomLeft: bottomLeft,
                  bottomRight: bottomRight,
                );
              },
            ),

            if (_loadingInProgress)
              const SliverPadding(
                padding: .all(PADDING),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: M3ELoadingIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
