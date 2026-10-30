import 'package:flavormate/core/constants/breakpoint_constants.dart';
import 'package:flavormate/core/constants/constants.dart';
import 'package:flavormate/data/models/local/pageable_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_3_expressive/components/loading_indicator/m3e_loading_indicator.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class FSliverGrid<T> extends ConsumerStatefulWidget {
  final $AsyncNotifierProvider<dynamic, PageableDto<T>> provider;

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

  const FSliverGrid({
    super.key,
    required this.provider,
    required this.rowHeight,
    required this.itemBuilder,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FSliverGrid<T>();
}

class _FSliverGrid<T> extends ConsumerState<FSliverGrid<T>> {
  bool _loadingInProgress = true;

  final List<T> _data = [];

  @override
  void initState() {
    ref.listenManual(widget.provider, fireImmediately: true, (_, asyncData) {
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
