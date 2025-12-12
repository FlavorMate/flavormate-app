import 'package:flavormate/presentation/common/widgets/f_data_table.dart';
import 'package:flutter/material.dart';

class FPaginatedContentTable<T> extends StatelessWidget {
  final List<T> data;
  final List<FDataColumn> columnBuilder;
  final FDataRow Function(T) rowBuilder;

  const FPaginatedContentTable({
    super.key,
    required this.data,
    required this.columnBuilder,
    required this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: FDataTable(
        columns: columnBuilder,
        rows: [
          for (final draft in data) rowBuilder.call(draft),
        ],
      ),
    );
  }
}
