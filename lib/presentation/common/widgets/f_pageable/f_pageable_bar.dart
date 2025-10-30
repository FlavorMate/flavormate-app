import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/core/riverpod/pageable_state/p_pageable_state.dart';
import 'package:flavormate/core/utils/u_riverpod.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_button.dart';
import 'package:flavormate/presentation/common/widgets/f_pageable/f_pageable_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FPageableBar<T> extends ConsumerStatefulWidget {
  static const double buttonWidth = 40.0;
  static const int maxVisiblePages = 6;
  static const String ellipsis = '...';

  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;
  final PPageableStateProvider pageProvider;

  final ScrollController controller;

  const FPageableBar({
    super.key,
    required this.provider,
    required this.pageProvider,
    required this.controller,
  });

  @override
  ConsumerState<FPageableBar> createState() => _FPageableBarState();
}

class _FPageableBarState extends ConsumerState<FPageableBar> {
  int _totalPages = 1;

  @override
  void initState() {
    URiverpod.listenManual(ref, widget.provider, (data) {
      if (data.metadata.totalPages != _totalPages) {
        setState(() => _totalPages = data.metadata.totalPages);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(widget.pageProvider);
    return Padding(
      padding: const EdgeInsets.all(PADDING / 2),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        spacing: PADDING / 2,
        children: _buildPaginationButtons(currentPage),
      ),
    );
  }

  List<Widget> _buildPaginationButtons(int currentPage) {
    final paginationLabels = _createPaginationLabels(currentPage);
    return paginationLabels.map((label) {
      final pageIndex = label == FPageableBar.ellipsis
          ? -1
          : int.parse(label) - 1;
      return FPageableButton(
        label: label,
        width: FPageableBar.buttonWidth,
        type: pageIndex == currentPage
            ? FPageableType.current
            : FPageableType.other,
        onPressed: () => _handlePageChange(label, pageIndex),
      );
    }).toList();
  }

  void _handlePageChange(String label, int pageIndex) {
    if (label != FPageableBar.ellipsis) {
      ref.read(widget.pageProvider.notifier).setPage(pageIndex);
    }
  }

  List<String> _createPaginationLabels(int currentPage) {
    if (_totalPages <= FPageableBar.maxVisiblePages) {
      return List.generate(_totalPages, (i) => (i + 1).toString());
    }

    return _createPaginationLabelsForLargeSet(currentPage);
  }

  List<String> _createPaginationLabelsForLargeSet(int currentPage) {
    if (currentPage <= 2) {
      return _createStartingPagesLabels();
    } else if (currentPage >= _totalPages - 4) {
      return _createEndingPagesLabels();
    }
    return _createMiddlePagesLabels(currentPage);
  }

  List<String> _createStartingPagesLabels() {
    return [
      ...List.generate(5, (i) => (i + 1).toString()),
      FPageableBar.ellipsis,
      _totalPages.toString(),
    ];
  }

  List<String> _createEndingPagesLabels() {
    return [
      '1',
      FPageableBar.ellipsis,
      ...List.generate(5, (i) => (_totalPages - 4 + i).toString()),
    ];
  }

  List<String> _createMiddlePagesLabels(int currentPage) {
    return [
      '1',
      FPageableBar.ellipsis,
      ...List.generate(3, (i) => (currentPage + i).toString()),
      FPageableBar.ellipsis,
      _totalPages.toString(),
    ];
  }

  void setPage(WidgetRef ref, int value) {
    ref.read(widget.pageProvider.notifier).setPage(value);
    widget.controller.jumpTo(0);
  }
}
