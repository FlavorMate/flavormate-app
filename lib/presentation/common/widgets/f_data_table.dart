import 'package:flutter/material.dart';

class FDataTable extends StatelessWidget {
  final double? width;
  final List<FDataColumn> columns;
  final List<FDataRow> rows;
  final double columnSpacing;
  final double horizontalMargin;

  FDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.columnSpacing = 10,
    this.horizontalMargin = 24,
    this.width = double.infinity,
  }) {
    if (columns.where((row) => row.width == null).length > 1) {
      throw Exception('Only one row is allowed to fill the rest space!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (_, constraints) {
          return DataTable(
            showCheckboxColumn: false,
            columnSpacing: columnSpacing,
            horizontalMargin: horizontalMargin,
            dataRowMaxHeight: double.infinity,
            columns: [
              for (final column in columns)
                DataColumn(
                  label: Builder(
                    builder: (context) {
                      var width = column.width;

                      if (column.width == null) {
                        final restWidth = columns
                            .where((row) => row.width != null)
                            .map((row) => row.width!)
                            .fold(0.0, (a, b) => a + b);

                        width =
                            constraints.minWidth -
                            restWidth -
                            (horizontalMargin * 2) -
                            (columnSpacing * (columns.length - 1));
                      }

                      return SizedBox(
                        width: width!,
                        child: Align(
                          alignment: column.alignment,
                          child: column.child,
                        ),
                      );
                    },
                  ),
                ),
            ],
            rows: [
              for (final row in rows)
                DataRow(
                  color: WidgetStateProperty.all(row.background),
                  onSelectChanged: row.onSelectChanged,
                  cells: [
                    for (final (index, cell) in row.cells.indexed)
                      DataCell(
                        Builder(
                          builder: (context) {
                            var width = columns[index].width;

                            if (columns[index].width == null) {
                              final restWidth = columns
                                  .where((row) => row.width != null)
                                  .map((row) => row.width!)
                                  .fold(0.0, (a, b) => a + b);

                              width =
                                  constraints.minWidth -
                                  restWidth -
                                  (horizontalMargin * 2) -
                                  (columnSpacing * (columns.length - 1));
                            }

                            return SizedBox(
                              width: width,
                              child: Align(
                                alignment: columns[index].alignment,
                                child: cell,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class FDataColumn {
  final double? width;
  final Alignment alignment;
  final Widget child;

  FDataColumn({
    this.width,
    this.alignment = Alignment.center,
    this.child = const SizedBox.shrink(),
  });
}

class FDataRow {
  final void Function(bool?)? onSelectChanged;
  final Color? background;
  final List<Widget> cells;

  FDataRow({this.onSelectChanged, this.background, required this.cells});
}
