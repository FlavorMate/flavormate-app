import 'package:flavormate/components/t_text.dart';
import 'package:flutter/material.dart';

class TTable extends StatefulWidget {
  final List<String> header;
  final List<List<String>> rows;
  final List<TextAlign>? cellTextAlign;
  final List<TextAlign>? headerTextAlign;
  final List<double>? distributions;

  TTable({
    required this.header,
    required this.rows,
    this.cellTextAlign,
    this.headerTextAlign,
    this.distributions,
    super.key,
  }) {
    final headerLength = header.length;

    if (headerLength == 0) {
      throw Exception(
        'The provided headers are empty. '
        'Please ensure that at least one header is provided.',
      );
    }

    if (distributions != null && distributions!.length != headerLength) {
      throw Exception(
        'The distributions property length should be either 0 or equal to the number of headers.'
        'Please ensure your distributions property aligns with this requirement.',
      );
    }

    if (!rows.every((row) => row.length == headerLength)) {
      throw Exception(
        'Mismatch found in cell length and header length. '
        'Each row should have the same number of cells as there are headers.',
      );
    }

    if (cellTextAlign != null &&
        cellTextAlign!.length != 1 &&
        cellTextAlign!.length != headerLength) {
      throw Exception(
        'The cellTextAlign property length should be either 0, 1, or equal to the number of headers.'
        'Please ensure your rowTextAlign property aligns with this requirement.',
      );
    }

    if (headerTextAlign != null &&
        headerTextAlign!.length != 1 &&
        headerTextAlign!.length != headerLength) {
      throw Exception(
        'The headerTextAlign property length should be either 0, 1, or equal to the number of headers.'
        'Please ensure your headerTextAlign property aligns with this requirement.',
      );
    }
  }

  @override
  State<TTable> createState() => _TTableState();
}

class _TTableState extends State<TTable> {
  late Map<int, FlexColumnWidth> _columnWidth;
  late List<TextAlign> _cellTextAligns;
  late List<TextAlign> _headerTextAligns;

  @override
  void initState() {
    if (widget.distributions == null) {
      // When distributions property is not provided, each column gets an equal width.
      _columnWidth = {
        for (var (index, _) in widget.header.indexed)
          index: const FlexColumnWidth(1)
      };
    } else {
      // In case that distributions property is provided, it assigns width for each column
      // according to corresponding item from the distributions property.
      _columnWidth = {
        for (var (index, distribution) in widget.distributions!.indexed)
          index: FlexColumnWidth(distribution)
      };
    }

    // Initialization for text alignment in cells.
    if (widget.cellTextAlign == null) {
      // If cellTextAlign property is not specified, set all cell alignments to start.
      _cellTextAligns =
          List.generate(widget.header.length, (_) => TextAlign.start);
    } else if (widget.header.length == widget.cellTextAlign!.length) {
      // If cellTextAlign property provided equals the length of headers,
      // each cell gets separate alignment according to corresponding item from cellTextAlign.
      _cellTextAligns = widget.cellTextAlign!;
    } else {
      // At this point the cellTextAlign length should be 1.
      // All cells get the same alignment specified by the first item in cellTextAlign.
      _cellTextAligns = List.generate(
        widget.header.length,
        (_) => widget.cellTextAlign!.first,
      );
    }

    // Initialization for text alignment in headers.
    if (widget.headerTextAlign == null) {
      // If headerTextAlign property is not specified, set all cell alignments to start.
      _headerTextAligns =
          List.generate(widget.header.length, (_) => TextAlign.start);
    } else if (widget.header.length == widget.headerTextAlign!.length) {
      // If headerTextAlign property provided equals the length of headers,
      // each cell gets separate alignment according to corresponding item from headerTextAlign.
      _headerTextAligns = widget.headerTextAlign!;
    } else {
      // At this point the headerTextAlign length should be 1.
      // All cells get the same alignment specified by the first item in headerTextAlign.
      _headerTextAligns = List.generate(
        widget.header.length,
        (_) => widget.headerTextAlign!.first,
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: _columnWidth,
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Theme.of(context).dividerColor,
          width: .5,
        ),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            for (var (index, head) in widget.header.indexed)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: TText(
                  head,
                  TextStyles.labelLarge,
                  textAlign: _headerTextAligns.elementAt(index),
                ),
              ),
          ],
        ),
        for (var row in widget.rows)
          TableRow(
            children: [
              for (var (index, cell) in row.indexed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Text(
                    cell,
                    textAlign: _cellTextAligns.elementAt(index),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
