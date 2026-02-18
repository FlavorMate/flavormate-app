import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_2d_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FLazyTable<T> extends ConsumerStatefulWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final ScrollController scrollController;

  final List<FExpressiveTableColumn<T>> columns;

  final void Function(int index, T item)? onRowTap;

  final double rowHeight;
  final double headerHeight;
  final bool pinnedHeader;
  final bool pinnedColumn;

  final EdgeInsets tablePadding;
  final EdgeInsets cellPadding;

  const FLazyTable({
    required super.key,
    required this.provider,
    required this.pageProvider,
    required this.scrollController,
    required this.columns,
    required this.onRowTap,
    this.rowHeight = 56,
    this.headerHeight = 56,
    this.pinnedHeader = true,
    this.pinnedColumn = false,
    this.tablePadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FLazyList<T>();
}

class _FLazyList<T> extends ConsumerState<FLazyTable<T>> {
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

    if (!canLoadMore && mounted) return;

    setState(() => _loadingInProgress = true);

    ref.read(widget.pageProvider.notifier).increment();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FExpressiveTableView<T>(
            scrollController: widget.scrollController,
            data: _data,
            columns: widget.columns,
            onRowTap: widget.onRowTap,
            rowHeight: widget.rowHeight,
            headerHeight: widget.headerHeight,
            pinnedHeader: widget.pinnedHeader,
            pinnedColumn: widget.pinnedColumn,
            tablePadding: widget.tablePadding,
            cellPadding: widget.cellPadding,
          ),
        ),
        if (_loadingInProgress)
          const Padding(
            padding: EdgeInsets.all(PADDING),
            child: Center(child: CircularProgressIndicator()),
          ),
        const SizedBox(height: PADDING),
        const SizedBox(height: kFabHeight),
        const SizedBox(height: PADDING),
      ],
    );
  }
}
