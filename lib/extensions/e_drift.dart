import 'package:drift/drift.dart';

extension EDrift on Migrator {
  Future<void> addColumnIfNotExists(
    TableInfo table,
    GeneratedColumn column,
  ) async {
    final List<QueryRow> queryRows = await database
        .customSelect(
          'SELECT name FROM pragma_table_info(?);',
          variables: <Variable<Object>>[
            Variable<String>(table.actualTableName),
          ],
        )
        .get();

    final List<String> columnNameList = queryRows
        .map((QueryRow e) => e.readNullable<String>('name'))
        .whereType<String>()
        .toList();

    if (columnNameList.contains(column.name)) {
      return;
    }

    await addColumn(table, column);
  }
}
