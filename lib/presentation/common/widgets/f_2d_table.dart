import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class FExpressiveTableView<T> extends StatefulWidget {
  const FExpressiveTableView({
    super.key,
    required this.data,
    required this.columns,
    this.scrollController,
    this.onRowTap,
    this.rowHeight = 56,
    this.headerHeight = 56,
    this.pinnedHeader = true,
    this.pinnedColumn = false,
    this.tablePadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final List<T> data;
  final List<FExpressiveTableColumn<T>> columns;

  /// Used for vertical scrolling (matches your page AppBar behavior).
  final ScrollController? scrollController;

  /// Called when a (non-header) row is tapped.
  final void Function(int index, T item)? onRowTap;

  final double rowHeight;
  final double headerHeight;
  final bool pinnedHeader;
  final bool pinnedColumn;

  final EdgeInsets tablePadding;
  final EdgeInsets cellPadding;

  @override
  State<FExpressiveTableView<T>> createState() =>
      _FExpressiveTableViewState<T>();
}

class _FExpressiveTableViewState<T> extends State<FExpressiveTableView<T>> {
  int? _hoveredRowIndex;
  int? _pressedRowIndex;

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;

    final scheduler = SchedulerBinding.instance;
    // We only defer if we are in the middle of a frame's layout/paint phase.
    // Deferring ensures we avoid "Build scheduled during frame" errors when
    // TableSpan objects are disposed during layout. In safe phases like idle,
    // we update immediately to ensure hover effects feel responsive and
    // don't get stuck waiting for a frame.
    if (scheduler.schedulerPhase != SchedulerPhase.persistentCallbacks) {
      setState(fn);
    } else {
      scheduler.addPostFrameCallback((_) {
        if (mounted) setState(fn);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.columns.isNotEmpty,
      'FExpressiveTableView requires at least 1 column.',
    );

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final headerBg = colorScheme.surfaceContainerHigh;
    final rowBgA = colorScheme.surface;
    final rowBgB = colorScheme.surfaceContainerLowest;
    final hoverBg = colorScheme.surfaceContainerLow;
    final pressedBg = colorScheme.surfaceContainer;
    final divider = colorScheme.outlineVariant;

    return LayoutBuilder(
      builder: (context, constraints) {
        final computedWidths = _computeColumnWidths(
          maxWidth: constraints.maxWidth,
          columns: widget.columns,
        );

        return MouseRegion(
          onExit: (_) {
            if (_hoveredRowIndex != null) {
              _safeSetState(() => _hoveredRowIndex = null);
            }
          },
          child: TableView.builder(
            rowCount: widget.data.length + 1,
            // + header row
            columnCount: widget.columns.length,
            pinnedRowCount: widget.pinnedHeader ? 1 : 0,
            pinnedColumnCount: widget.pinnedColumn ? 1 : 0,
            verticalDetails: ScrollableDetails.vertical(
              controller: widget.scrollController,
            ),
            horizontalDetails: const ScrollableDetails.horizontal(),
            rowBuilder: (rowIndex) {
              final isHeader = rowIndex == 0;
              final isHovered = _hoveredRowIndex == rowIndex;
              final isPressed = _pressedRowIndex == rowIndex;

              final Color bg;
              if (isHeader) {
                bg = headerBg;
              } else if (isPressed) {
                bg = pressedBg;
              } else if (isHovered) {
                bg = hoverBg;
              } else {
                bg = rowIndex.isEven ? rowBgA : rowBgB;
              }

              return TableSpan(
                onEnter: (_) {
                  if (_hoveredRowIndex != rowIndex) {
                    _safeSetState(() => _hoveredRowIndex = rowIndex);
                  }
                },
                onExit: (_) {
                  if (_hoveredRowIndex == rowIndex) {
                    _safeSetState(() => _hoveredRowIndex = null);
                  }
                },
                cursor: (widget.onRowTap != null && !isHeader)
                    ? SystemMouseCursors.click
                    : MouseCursor.defer,
                extent: FixedTableSpanExtent(
                  isHeader ? widget.headerHeight : widget.rowHeight,
                ),
                backgroundDecoration: TableSpanDecoration(
                  color: bg,
                  border: TableSpanBorder(
                    leading: rowIndex == 0
                        ? BorderSide.none
                        : BorderSide(color: divider, width: 1),
                  ),
                ),
              );
            },
            columnBuilder: (colIndex) {
              return TableSpan(
                extent: FixedTableSpanExtent(computedWidths[colIndex]),
              );
            },
            cellBuilder: (context, vicinity) {
              final colIndex = vicinity.xIndex;
              final rowIndex =
                  vicinity.yIndex - 1; // -1 because header is row 0
              final column = widget.columns[colIndex];

              if (rowIndex < 0) {
                return TableViewCell(
                  child: Padding(
                    padding: widget.cellPadding,
                    child: DefaultTextStyle(
                      style: (textTheme.labelLarge ?? const TextStyle())
                          .copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                      child: Align(
                        alignment: column.alignment,
                        child: column.header,
                      ),
                    ),
                  ),
                );
              }

              final item = widget.data[rowIndex];
              final cellChild = DefaultTextStyle(
                style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                  color: colorScheme.onSurface,
                ),
                child: Align(
                  alignment: column.alignment,
                  child: column.cellBuilder(context, item, rowIndex),
                ),
              );

              final cell = Padding(
                padding: widget.cellPadding,
                child: cellChild,
              );

              if (widget.onRowTap != null) {
                final absoluteRowIndex = vicinity.yIndex;
                if (column.enableRowTap) {
                  return TableViewCell(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (_) {
                        if (_pressedRowIndex != absoluteRowIndex) {
                          _safeSetState(
                            () => _pressedRowIndex = absoluteRowIndex,
                          );
                        }
                      },
                      onTapUp: (_) {
                        if (_pressedRowIndex != null) {
                          _safeSetState(() => _pressedRowIndex = null);
                        }
                      },
                      onTapCancel: () {
                        if (_pressedRowIndex != null) {
                          _safeSetState(() => _pressedRowIndex = null);
                        }
                      },
                      onTap: () => widget.onRowTap?.call(rowIndex, item),
                      child: cell,
                    ),
                  );
                } else {
                  return TableViewCell(
                    child: GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.opaque,
                      child: cell,
                    ),
                  );
                }
              }

              return TableViewCell(child: cell);
            },
          ),
        );
      },
    );
  }

  static List<double> _computeColumnWidths<T>({
    required double maxWidth,
    required List<FExpressiveTableColumn<T>> columns,
  }) {
    double effectiveFixedWidth(FExpressiveTableColumn<T> c) {
      final fixed = c.fixedWidth;
      if (fixed == null) return 0.0;
      return math.max(fixed, c.minWidth ?? 0.0);
    }

    final fixedTotal = columns
        .map(effectiveFixedWidth)
        .fold<double>(0, (a, b) => a + b);

    final flexTotal = columns
        .map((c) => c.flex)
        .fold<double>(0, (a, b) => a + (b <= 0 ? 0 : b));

    final remaining = math.max(0.0, maxWidth - fixedTotal);

    // Minimum width for flex columns to ensure they are visible on small screens.
    const minFlexWidth = 80.0;

    double flexUnitWidth = 0;
    if (flexTotal > 0) {
      flexUnitWidth = math.max(minFlexWidth, remaining / flexTotal);
    }

    return [
      for (final c in columns)
        if (c.fixedWidth != null)
          effectiveFixedWidth(c)
        else if (c.flex > 0)
          math.max(c.minWidth ?? 0.0, flexUnitWidth * c.flex)
        else
          (c.minWidth ?? 0.0),
    ];
  }
}

class FExpressiveTableColumn<T> {
  const FExpressiveTableColumn({
    required this.header,
    required this.cellBuilder,
    this.fixedWidth,
    this.minWidth,
    this.flex = 0,
    this.alignment = Alignment.centerLeft,
    this.enableRowTap = true,
  });

  /// Provide either [fixedWidth] or a positive [flex].
  final double? fixedWidth;

  /// Minimum width this column is allowed to shrink to.
  ///
  /// Applies to both [fixedWidth] and [flex] columns.
  final double? minWidth;

  final double flex;

  final Alignment alignment;

  /// Whether this column participates in row-tap (useful to exclude action columns).
  final bool enableRowTap;

  final Widget header;

  /// (context, item, rowIndex) -> Widget
  final Widget Function(BuildContext context, T item, int rowIndex) cellBuilder;
}
