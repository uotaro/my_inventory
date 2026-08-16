import 'package:drift/drift.dart';

import 'items_table.dart';

@DataClassName('StockLog')
class StockLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id)();
  RealColumn get changeAmount => real()();
  TextColumn get reason => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
