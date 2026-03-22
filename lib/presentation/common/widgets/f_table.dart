import 'package:flutter/material.dart';

class FTable extends StatefulWidget {
  final List<Widget> header;
  final List<List<Widget>> rows;
  final List<TextAlign>? cellTextAlign;
  final List<TextAlign>? headerTextAlign;
  final List<double>? distributions;

  FTable({
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
  State<FTable> createState() => _FTableState();
}

class _FTableState extends State<FTable> {
  late Map<int, FlexColumnWidth> _columnWidth;

  @override
  void initState() {
    if (widget.distributions == null) {
      // When distributions property is not provided, each column gets an equal width.
      _columnWidth = {
        for (var (index, _) in widget.header.indexed)
          index: const FlexColumnWidth(1),
      };
    } else {
      // In case that distributions property is provided, it assigns width for each column
      // according to corresponding item from the distributions property.
      _columnWidth = {
        for (var (index, distribution) in widget.distributions!.indexed)
          index: FlexColumnWidth(distribution),
      };
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
            for (var head in widget.header)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: head,
              ),
          ],
        ),
        for (var row in widget.rows)
          TableRow(
            children: [
              for (var cell in row)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: cell,
                ),
            ],
          ),
      ],
    );
  }
}
